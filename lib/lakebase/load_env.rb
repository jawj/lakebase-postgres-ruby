require 'dotenv/load'

# see .env.example for example environment variable values
Dotenv.require_keys(%w{
  OIDC_URL
  CLIENT_ID
  CLIENT_SECRET
  PG_TOKEN_URL
  LAKEBASE_PROJECT
  LAKEBASE_BRANCH
  LAKEBASE_ENDPOINT
  PG_HOST
  PG_DATABASE
})
