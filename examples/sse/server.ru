require "rubygems"
require "bundler"
Bundler.setup(:default, :example)

require 'cramp'
require 'http_router'
require 'active_support/json'

class TimeController < Cramp::SSE
  on_start :send_latest_time
  periodic_timer :send_latest_time, :every => 2

  def send_latest_time
    data = {'time' => Time.now.to_i}.to_json

    # render data, :retry => 10
    render data
  end
end

routes = HttpRouter.new do
  add('/sse').to(TimeController)
end

file_server = Rack::File.new(File.join(File.dirname(__FILE__), 'public'))

# bundle exec thin -V -R examples/sse/server.ru start
run Rack::Cascade.new([file_server, routes])
