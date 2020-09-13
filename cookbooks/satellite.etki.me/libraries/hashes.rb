module Etki
  module Satellite
    module Hashes
      class << self
        def get(hash, *keys)
          keys.map { |key| hash[key.to_sym] || hash[key.to_s] }
        end

        def fetch(hash, *keys)
          keys.map { |key| hash.fetch(key.to_sym) || hash.fetch(key.to_s) }
        end

        def key?(hash, key)
          hash.key?(key.to_sym) || hash.key?(key.to_s)
        end

        def sanitize(hash)
          target = {}
          hash.each do |key, value|
            sanitized_key = key.respond_to?(:to_sym) ? key.to_sym : key
            target[sanitized_key] = value
          end
          target
        end
      end
    end
  end
end
