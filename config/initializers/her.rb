require 'settings'
require 'her'
require 'faraday_middleware'

Settings.cap ||= {}
Settings.cap[:protocol] ||= 'http'
Settings.cap[:api_host] ||= Settings.cap[:host] || 'localhost'
Settings.cap[:api_port] ||= Settings.cap[:port] || 8003

YB = Her::API.new
YB.setup url: "#{Settings.yearbook.protocol}://#{Settings.yearbook.api_host}:#{Settings.yearbook.api_port}" do |c|
  # Request
  c.use FaradayMiddleware::EncodeJson
  # Response
  c.use Her::Middleware::JsonApiParser
  c.use Faraday::Adapter::NetHttp
end
