# frozen_string_literal: true

module Comunit
  module Network
    # Helper for introducing new site to network
    class SyncHelper
      attr_accessor :site

      # @param [Site] site
      def initialize(site)
        self.site = site
      end

      def introduce
        site.update!(active: true)
        sync_sites
        sync_users
        sync_simple_images
      end

      def sync_sites
        puts 'Updating sites...'
        handler = Comunit::Network::SiteHandler.new(site)
        Site.order('id asc').each do |s|
          puts "#{s.host} -> #{site.host}"
          handler.push(s)
          next if s.id == site.id

          puts "#{site.host} -> #{s.host}"
          NetworkEntitySyncJob.perform_now(s.class.to_s, site.id, s.uuid)
        end
        puts 'Done'
      end

      def sync_users
        puts 'Pushing users...'
        handler = Comunit::Network::UserHandler.new(site)
        User.order('id asc').each do |u|
          print "\r#{u.id} #{u.screen_name} "
          handler.push(u)
        end
        puts "\nDone."
      end

      def sync_simple_images
        puts 'Pushing simple images...'
        handler = Comunit::Network::SimpleImageHandler.new(site)
        SimpleImage.order('id asc').each do |entity|
          print "\r#{entity.id} "
          handler.push(entity)
        end
        puts "\nDone."
      end
    end
  end
end
