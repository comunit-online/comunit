Rails.application.routes.draw do
  mount Comunit::Local::Engine => "/comunit-local"
end
