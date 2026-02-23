require 'net/http'
require 'uri'
require 'json'

module Lakebase
  module Auth
    def self.api_credentials(oidc_url, client_id, client_secret)
      puts("#{Time.now.iso8601(3)} Fetching API auth token from #{oidc_url} ...");
      
      t0 = Time.now
      auth = ["#{client_id}:#{client_secret}"].pack('m0') # m0 = base64, no linefeeds
      post_data = 'grant_type=client_credentials&scope=all-apis' # there's currently no Lakebase scope
      response = Net::HTTP.post(URI(oidc_url), post_data, {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Basic #{auth}",
      })
      credentials = JSON.parse(response.body)
      
      unless response.is_a?(Net::HTTPOK)
        raise "#{response.code} #{response.message}: #{credentials['error_description']}"
      end

      token = credentials['access_token']
      expires = t0 + credentials['expires_in'] # expires_in is in seconds
      
      puts("#{Time.now.iso8601(3)} Lakebase API auth token fetched, expires around #{expires}");
      { token: token, expires: expires }
    end
  end
end
