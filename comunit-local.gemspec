$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "comunit/local/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "comunit-local"
  s.version     = Comunit::Local::VERSION
  s.authors     = ["Maxim Khan-Magomedov"]
  s.email       = ["maxim.km@gmail.com"]
  s.homepage    = "https://github.com/Biovision/comunit-local"
  s.summary     = "Local version of site in Comunit network."
  s.description = "Everything needed to setup and run site in Comunit network."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 5.1'
  s.add_dependency 'rails-i18n', '~> 5.0'

  s.add_dependency 'bcrypt', '~> 3.1'
  s.add_dependency 'carrierwave', '~> 1.2'
  s.add_dependency 'carrierwave-bombshelter', '~> 0.2'
  s.add_dependency 'kaminari', '~> 1.1'
  s.add_dependency 'mini_magick', '~> 4.8'
  s.add_dependency 'elasticsearch-model', '~> 5.0'
  s.add_dependency 'elasticsearch-persistence', '~> 5.0'
  s.add_dependency 'redis-namespace', '~> 1.6'
  s.add_dependency 'sidekiq', '~> 5.0'

  s.add_development_dependency 'database_cleaner', '~> 1.6'
  s.add_development_dependency 'factory_bot_rails', '~> 4.8'
  s.add_development_dependency 'pg', '~> 0.20'
  s.add_development_dependency 'rspec-rails', '~> 3.7'
end
