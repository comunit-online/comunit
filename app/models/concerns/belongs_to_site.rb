# frozen_string_literal: true

# Model belongs to site
module BelongsToSite
  extend ActiveSupport::Concern

  included do
    after_initialize :ensure_site_presence

    scope :for_current_site, -> { for_site(Site[ENV['SITE_ID']]) }
    scope :for_site, ->(v) do
      return if v.blank?

      root_key = Comunit::Network::Handler::ROOT_KEY
      site_key = Comunit::Network::Handler::SITE_KEY
      path = "data->'#{root_key}'->>'#{site_key}'"
      where("coalesce(#{path}, '') in (?, '')", v.uuid)
    end

    def ensure_site_presence
      return unless site_uuid.blank?

      root_key = Comunit::Network::Handler::ROOT_KEY
      site_key = Comunit::Network::Handler::SITE_KEY
      data[root_key] ||= {}
      data[root_key][site_key] = ENV['SITE_ID']
    end

    def site
      return if site_uuid.nil?

      Site[site_uuid]
    end

    def site_uuid
      root_key = Comunit::Network::Handler::ROOT_KEY
      site_key = Comunit::Network::Handler::SITE_KEY
      data.dig(root_key, site_key)
    end
  end
end
