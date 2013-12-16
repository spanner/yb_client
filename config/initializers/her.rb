require 'her'
require 'settings'
require 'her/paginated_model'
require 'her/middleware/token_auth'
require 'her/middleware/paginated_parser'

Her::API.setup base_uri: "#{Settings.cdb.protocol}://#{Settings.cdb.host}/api" do |c|
  c.use Her::Middleware::TokenAuth
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::PaginatedParser
  c.use Faraday::Adapter::NetHttp
end

DROOM = Her::API.new base_uri: "#{Settings.droom.protocol}://#{Settings.droom.host}/api" do |c|
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::TokenAuth
  c.use Her::Middleware::PaginatedParser
  c.use Faraday::Adapter::NetHttp
end

