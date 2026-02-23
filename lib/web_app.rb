# run with: bundle exec ruby lib/web_app.rb

require 'sinatra'
require 'active_record'
require_relative 'lakebase/pg_config'
require_relative 'lakebase/pg_dynamic_password'

pg_config = Lakebase::PGConfig.new.dynamic_config
ActiveRecord::Base.establish_connection(adapter: 'postgresql', **pg_config)

get '/' do
  result = ActiveRecord::Base.connection.execute('SELECT now()')
  "The time is: #{result.first['now']}"
end
