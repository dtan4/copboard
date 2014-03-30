class App < Sinatra::Base
  set :sprockets, Sprockets::Environment.new

  configure do
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix = "/assets"
      config.digest = true
    end

    sprockets.append_path "assets/javascripts"
    sprockets.append_path "assets/stylesheets"
    sprockets.append_path Bootstrap.javascripts_path
    sprockets.append_path Bootstrap.stylesheets_path
    sprockets.append_path Bootstrap.fonts_path
  end

  helpers Sprockets::Helpers

  get "/" do
    slim :index
  end
end
