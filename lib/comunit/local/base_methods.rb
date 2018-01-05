module Comunit
  module Local
    module BaseMethods
      extend ActiveSupport::Concern

      included do
        helper_method :current_page, :param_from_request
        helper_method :current_user
        helper_method :current_user_has_privilege?, :current_user_in_group?
        helper_method :current_region
      end

      # Get current page number from request
      #
      # @return [Integer]
      def current_page
        @current_page ||= (params[:page] || 1).to_s.to_i.abs
      end

      # Get parameter from request and normalize it
      #
      # Casts request parameter to UTF-8 string and removes invalid characters
      #
      # @param [Symbol] param
      # @return [String]
      def param_from_request(param)
        params[param].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
      end

      # Get current user from token cookie
      #
      # @return [User|nil]
      def current_user
        @current_user ||= Token.user_by_token cookies['token'], true
      end
      def current_region
        @current_region ||= set_current_region
      end

      # @param [Symbol] privilege_name
      # @param [Region] region
      def current_user_has_privilege?(privilege_name, region = nil)
        ::UserPrivilege.user_has_privilege?(current_user, privilege_name, region)
      end

      # @param [Symbol] group_name
      def current_user_in_group?(group_name)
        ::UserPrivilege.user_in_group?(current_user, group_name)
      end

      protected

      # Handle HTTP error with status 404 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_404(message, metric = nil, view = :not_found)
        status         = :not_found
        default_metric = Metric::METRIC_HTTP_404
        handle_http_error(message, metric || default_metric, view, status)
      end

      # Handle HTTP error with status 401 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_401(message, metric = nil, view = :unauthorized)
        status         = :unauthorized
        default_metric = Metric::METRIC_HTTP_401
        handle_http_error(message, metric || default_metric, view, status)
      end

      # Handle generic HTTP error without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [String|Symbol] view
      # @param [Symbol] status
      def handle_http_error(message, metric, view = :error, status = 500)
        logger.warn "#{message}\n\t#{request.method} #{request.original_url}"
        Metric.register(metric)
        render view, status: status
      end

      # Restrict access for anonymous users
      def restrict_anonymous_access
        handle_http_401('Restricted anonymous access') if current_user.nil?
      end

      # Owner information for entity
      #
      # @param [Boolean] track
      def owner_for_entity(track = false)
        result = { user: current_user }
        result.merge!(tracking_for_entity) if track
        result
      end

      # @return [Agent]
      def agent
        @agent ||= Agent.named(request.user_agent)
      end

      # @return [Hash]
      def tracking_for_entity
        { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
      end

      # @param [Symbol] privilege_name
      def require_privilege(privilege_name)
        return if current_user_has_privilege?(privilege_name, current_region)
        handle_http_401("Current user has no privilege #{privilege_name}")
      end

      # @param [Symbol] group_name
      def require_privilege_group(group_name)
        return if current_user_in_group?(group_name)
        handle_http_401("Current user is not in group #{group_name}")
      end

      def set_current_region
        region_slug = param_from_request(:region_slug)
        if region_slug.blank?
          region_slug = request.subdomains.first
        end
        if region_slug.blank?
          @current_region = CentralRegion.new
        else
          @current_region = Region.find_by(long_slug: region_slug) || CentralRegion.new
        end
      end
    end
  end
end