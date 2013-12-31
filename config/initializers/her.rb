require 'settings'
require 'paginated_her'

CDB = Her::API.new
CDB.setup url: "#{Settings.cdb.protocol}://#{Settings.cdb.host}/api" do |c|
  c.use Faraday::Request::UrlEncoded
  c.use PaginatedHer::Middleware::TokenAuth
  c.use PaginatedHer::Middleware::Parser
  c.use Faraday::Adapter::NetHttp
end
