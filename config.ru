require './app/hydra.rb'


run Rack::URLMap.new('/' => App, '/sidekiq' => Sidekiq::Web)
