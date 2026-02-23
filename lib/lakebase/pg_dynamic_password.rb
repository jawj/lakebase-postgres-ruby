require 'pg'

module CallablePasswordParam
  # patch pg to support a callable object as the :password key of the config hash
  def parse_connect_args(*args)
    return super(*args) unless args.last.is_a?(Hash)

    hash_arg = args.pop.transform_keys(&:to_sym)
    hash_arg[:password] = hash_arg[:password].call if hash_arg[:password].respond_to?(:call)
    super(*args, hash_arg)
  end
end

PG::Connection.singleton_class.prepend(CallablePasswordParam)
