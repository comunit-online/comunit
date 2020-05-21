$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "comunit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "comunit"
  spec.version     = Comunit::VERSION
  spec.authors     = ["Maxim Khan-Magomedov"]
  spec.email       = ["maxim.km@gmail.com"]
  spec.homepage    = "https://github.com/Biovision/comunit"
  spec.summary     = "Base gem for Comunit sites"
  spec.description = "Base gem fir buidling central and remote comunit sites"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.1"
  spec.add_dependency 'rails-i18n', '~> 6.0'

  spec.add_dependency 'biovision'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'

  spec.add_development_dependency "pg"
end
