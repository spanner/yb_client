require 'settings'
require 'paginated_authorized_her'

CDB = Her::API.new base_uri: "#{Settings.cdb.protocol}://#{Settings.cdb.host}/api" do |c|
  c.use Her::Middleware::TokenAuth
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::PaginatedParser
  c.use Faraday::Adapter::NetHttp
end
