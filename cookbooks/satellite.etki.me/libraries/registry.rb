require_relative 'registry/configuration'
require_relative 'registry/paths'
require_relative 'registry/machine'
require_relative 'registry/containers'
require_relative 'registry/services'

module Etki
  module Satellite
    class Registry
      # @!attribute coinfiguration
      #   @return [Configuration]
      attr_reader :configuration
      # @!attribute paths
      #   @return [Paths]
      attr_reader :paths
      # @!attribute machine
      #   @return [Machine]
      attr_reader :machine
      # @!attribute containers
      #   @return [Containers]
      attr_reader :containers
      # @!attribute services
      #   @return [Services]
      attr_reader :services

      def initialize(node)
        @configuration = Configuration.new(node[Constants.project])
        @paths = Paths.new(configuration.traverse!(:paths))
        @machine = Machine.new(configuration.traverse!(:machine), Configuration.new(node))
        @containers = Containers.new(configuration.traverse!(:containers), machine)
        @services = Services.new(configuration.traverse(:services), paths, machine, containers)
      end
    end
  end
end
