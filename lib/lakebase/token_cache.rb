module Lakebase
  class TokenCache
    EXPIRY_BUFFER = 180 # seconds

    def initialize(expiry_buffer = EXPIRY_BUFFER, &block)
      @lock = Mutex.new
      @block = block
      @expiry_buffer = expiry_buffer
    end

    def token
      @lock.synchronize do
        if @token.nil? || Time.now >= @buffered_expiry
          credentials = @block.call
          @token = credentials[:token]
          @buffered_expiry = credentials[:expires] - @expiry_buffer
        end
        @token
      end
    end
  end
end
