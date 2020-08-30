require 'set'

module Etki
  module Satellite
    class Service
      class Interface
        # @!attribute port
        #   @return [Integer]
        attr_accessor :port

        # @!attribute protocol
        #   @return [Symbol] One of: :https, :http, :tcp, :udp
        attr_accessor :protocol

        # @!attribute address
        #   @return [String, NilClass]
        attr_accessor :address

        class << self
          def create(port, protocol = :tcp, address = nil)
            Interface.new.tap do |instance|
              instance.port = port
              instance.protocol = protocol || :tcp
              instance.address = address
            end
          end

          def normalize(value)
            return value if value.is_a?(Interface) || value.nil?

            return create(*Hashes.get(value, :port, :protocol, :address)) if value.is_a?(Hash)

            return create(value) if value.is_a?(Integer)

            raise "Can't normalize value of #{value.class}"
          end
        end
      end
    end
  end
end
