# run with: bundle exec ruby lib/one_shot.rb

require 'pg'
require_relative 'lakebase/pg_config'

pg_config = Lakebase::PGConfig.new.static_config
conn = PG.connect(pg_config)

result = conn.exec('SELECT now()')
puts("#{Time.now.iso8601(3)} Result: #{result.first['now']}")

conn.close
