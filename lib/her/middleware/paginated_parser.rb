# https://gist.github.com/letronje/437b4a72225eb53366c6
#
module Her::Middleware
  class PaginatedParser  < Faraday::Response::Middleware

    def on_complete(env)
      json = JSON.parse(env[:body], :symbolize_names => true)
      errors = json.delete(:errors) || {}
      metadata = json.delete(:metadata) || []
      body = {:data => json, :errors => errors, :metadata => metadata}
      if env[:response_headers]["X-Pagination"]
        body[:pagination] = JSON.parse(env[:response_headers]["X-Pagination"], :symbolize_names => true)
      end
      env[:body] = body
    end

  end
end