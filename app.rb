require "json"
require "open3"
require "pathname"

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

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
  end

  helpers Sprockets::Helpers

  helpers do
    def get_rubocop_result(dir)
      dir_path = Pathname.new(dir).realpath
      return JSON.generate(status: false) unless Dir.exist?(dir_path.to_s)

      out, _ = Open3.capture2("rubocop --format json #{dir}")
      hash = JSON.parse(out, symbolize_names: true)
      hash[:files] = hash[:files].map do |file|
        path = Pathname.new(file[:path])
        file[:path] = path.realpath.relative_path_from(dir_path).to_s
        file
      end

      hash[:status] = true
      JSON.generate(hash)
    rescue
      JSON.generate(status: false)
    end
  end

  get "/" do
    slim :index
  end

  get "/analyze" do
    content_type :json

    dir = params[:dir]
    result = get_rubocop_result(dir)
    result
  end
end
