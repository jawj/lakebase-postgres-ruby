require 'pg'

module CallablePasswordParam
  # patch pg to support a lambda, Proc, etc. as the :password config key
  def parse_connect_args(*args)
    return super(*args) unless args.last.is_a?(Hash)

    hash = args.pop.transform_keys(&:to_sym)
    hash[:password] = hash[:password].call if hash[:password].respond_to?(:call)
    super(*args, hash)
  end
end

PG::Connection.singleton_class.prepend(CallablePasswordParam)
