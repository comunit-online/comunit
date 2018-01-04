module Comunit
  module Local
    require 'carrierwave'
    require 'carrierwave-bombshelter'
    require 'elasticsearch/model'
    require 'elasticsearch/persistence'
    require 'kaminari'
    require 'mini_magick'
    require 'rails_i18n'
    require 'redis-namespace'
    require 'sidekiq'

    class Engine < ::Rails::Engine
      config.to_prepare do
        Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
          require_dependency(c)
        end
      end

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      end
    end
  end
end
