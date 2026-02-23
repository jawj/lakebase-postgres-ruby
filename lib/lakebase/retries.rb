module Lakebase
  module Retries
    def self.with_schedule(delays = [0.05, 0.5, 5.0])
      delays.each do |delay|
        begin
          return yield
        rescue => e
          puts("Retrying in #{delay}s after error: #{e.message}")
          sleep(delay)
        end
      end
      yield # final attempt: error will not be rescued
    end
  end
end
