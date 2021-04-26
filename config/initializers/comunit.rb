# frozen_string_literal: true

Rails.application.configure do
  engine_root = File.expand_path('../../..', __FILE__)
  overrides = "#{engine_root}/app/overrides"

  Rails.autoloaders.main.ignore(overrides)
  config.to_prepare do
    Dir.glob("#{overrides}/**/*_override.rb").each do |override|
      load override
    end
  end
end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'taxon', 'taxa'
end
