require 'net/http'
require 'uri'
require 'json'
require 'time'

module Lakebase
  module Auth
    def self.pg_credentials(api_url, api_token, endpoint, params = {})
      puts("#{Time.now.iso8601(3)} Fetching Lakebase Postgres auth token from #{api_url} ...");

      # let api_token be a string or something with a `token` method
      api_token = api_token.token if api_token.respond_to?(:token)

      post_data = { **params, endpoint: endpoint }.to_json
      response = Net::HTTP.post(URI(api_url), post_data, {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_token}",
      })

      credentials = JSON.parse(response.body)
      
      unless response.is_a?(Net::HTTPOK)
        raise "#{response.code} #{response.message}: #{credentials['error_code']} #{credentials['message']}"
      end

      token = credentials['token']
      expires = Time.iso8601(credentials['expire_time']) # expire_time is an ISO8601 string

      puts("#{Time.now.iso8601(3)} Lakebase Postgres auth token fetched, expires at #{expires}")
      { token: token, expires: expires }
    end
  end
end
