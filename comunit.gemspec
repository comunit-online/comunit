require_relative "lib/comunit/version"

Gem::Specification.new do |spec|
  spec.name        = "comunit"
  spec.version     = Comunit::VERSION
  spec.authors     = ["Maxim Khan-Magomedov"]
  spec.email       = ["maxim.km@gmail.com"]
  spec.homepage    = "https://github.com/Biovision/comunit"
  spec.summary     = "Base gem for Comunit sites"
  spec.description = "Base gem for buidling central and remote comunit sites"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Biovision/comunit"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.3", ">= 6.1.3.1"
  spec.add_dependency 'rails-i18n', '~> 6.0'

  spec.add_dependency 'biovision'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
end
