require 'settings'
require 'her/paginated_model'
require 'her/middleware/token_auth'
require 'her/middleware/paginated_parser'

Her::API.setup url: "#{Settings.droom.protocol}://#{Settings.droom.host}/api" do |c|
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::TokenAuth
  c.use Her::Middleware::PaginatedParser
  c.use Faraday::Adapter::NetHttp
end
