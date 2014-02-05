require 'settings'
require 'paginated_her'
require 'memcached'
require 'faraday_middleware/response/caching'

Settings.cdb[:protocol] ||= 'http'
Settings.cdb[:port] ||= '80'
Settings[:memcached] ||= {}
Settings.memcached[:host] ||= nil
Settings.memcached[:port] ||= nil
Settings.memcached[:ttl] ||= 10.minutes

if Settings.memcached.host && Settings.memcached.port
  $cache ||= Memcached::Rails.new("#{Settings.memcached.host}:#{Settings.memcached.port}", logger: Rails.logger, default_ttl: Settings.memcached.ttl)
end

CDB = Her::API.new
CDB.setup url: "#{Settings.cdb.protocol}://#{Settings.cdb.host}:#{Settings.cdb.port}/api" do |c|
  # Request
  c.use FaradayMiddleware::Caching, $cache.clone if $cache
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use PaginatedHer::Middleware::Parser
  c.use Faraday::Adapter::NetHttp
end



