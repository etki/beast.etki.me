require_relative 'service/forwarding'

module Etki
  module Satellite
    class Service
      # @!attribute name
      #   @return [String]
      attr_accessor :name
      # @!attribute public_address
      #   @return [String]
      attr_accessor :public_address
      # @!attribute private_address
      #   @return [String]
      attr_accessor :private_address
      # @!attribute interfaces
      #   @return [Array<Forwarding>]
      attr_accessor :interfaces
      # @!attribute ingress
      #   @return [Array<IngressRule>]
      attr_accessor :ingress
      # @!attribute mounts
      #   @return [Array<Mount>]
      attr_accessor :mounts
      # @!attribute devices
      #   @return [Array<Mount>]
      attr_accessor :devices
      # @!attribute workspace_directory
      #   @return [Pathname]
      attr_accessor :workspace_directory
      # @!attribute configuration_directory
      #   @return [Pathname]
      attr_accessor :configuration_directory
      # @!attribute state_directory
      #   @return [Pathname]
      attr_accessor :state_directory
      # @!attribute certificate_directory
      #   @return [Pathname]
      attr_accessor :certificate_directory
      # @!attribute active_certificate_directory
      #   @return [Pathname]
      attr_accessor :active_certificate_directory
      # @!attribute ingress_workspace_directory
      #   @return [Pathname]
      attr_accessor :ingress_workspace_directory

      def normalize
        dup.tap(&:normalize!)
      end

      def normalize!
        self.ingress = IngressRule.normalize_many(ingress)
        self.interfaces = Forwarding.normalize_many(interfaces)
        self.mounts = Mount.normalize_many(mounts)
        self.devices = Mount.normalize_many(devices)
      end
    end
  end
end
