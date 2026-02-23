require_relative 'load_env.rb'
require_relative 'token_cache.rb'
require_relative 'retries.rb'
require_relative 'auth/api_credentials.rb'
require_relative 'auth/pg_credentials.rb'

module Lakebase
  class PGConfig
    def initialize
      api_token_cache = Lakebase::TokenCache.new do
        Lakebase::Retries.with_schedule do
          Lakebase::Auth::api_credentials(
            ENV['OIDC_URL'],
            ENV['CLIENT_ID'],
            ENV['CLIENT_SECRET'],
          )
        end
      end

      @pg_token_cache = Lakebase::TokenCache.new do
        Lakebase::Retries.with_schedule do
          Lakebase::Auth::pg_credentials(
            ENV['PG_TOKEN_URL'],
            api_token_cache,
            "projects/#{ENV['LAKEBASE_PROJECT']}/branches/#{ENV['LAKEBASE_BRANCH']}/endpoints/#{ENV['LAKEBASE_ENDPOINT']}",
          )
        end
      end
    end

    def config_without_password
      {
        host: ENV['PG_HOST'],
        dbname: ENV['PG_DATABASE'],
        user: ENV['CLIENT_ID'],
      }
    end

    def password
      @pg_token_cache.token
    end

    def static_config
      {
        **config_without_password,
        password: password,
      }
    end

    def dynamic_config
      {
        **config_without_password,
        password: lambda { password },
      }
    end
  end
end
