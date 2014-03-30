require "bundler"
Bundler.require

require "./app.rb"

map "/assets" do
  run App.sprockets
end

map "/" do
  run App
end
