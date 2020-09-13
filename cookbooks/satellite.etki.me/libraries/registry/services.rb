module Etki
  module Satellite
    class Registry
      class Services
        private

        # @!attribute configuration
        #   @return [Etki::Satellite::Registry::Configuration]
        attr_reader :configuration
        # @!attribute paths
        #   @return [Etki::Satellite::Registry::Paths]
        attr_reader :paths
        # @!attribute machine
        #   @return [Etki::Satellite::Registry::Machine]
        attr_reader :machine
        # @!attribute containers
        #   @return [Etki::Satellite::Registry::Containers]
        attr_reader :containers

        public

        def initialize(configuration, paths, machine, containers)
          @configuration = configuration
          @paths = paths
          @machine = machine
          @containers = containers
        end

        def public_address(name)
          value = configuration[:service, name, :public_address]
          value || "#{name}.#{machine.advertised_name}"
        end

        def private_address(name)
          value = configuration[:service, name, :private_address]
          value || "#{public_address(name)}.#{containers.qualified_network_name}"
        end

        # @return [Pathname]
        def workspace_directory(name)
          paths.workspace.join('service', name.to_s)
        end

        # @return [Pathname]
        def workspace_path(name, *path)
          workspace_directory(name).join(*path.map(&:to_s))
        end

        # @return [Pathname]
        def configuration_directory(name)
          paths.configuration.join('service', name.to_s)
        end

        # @return [Pathname]
        def configuration_path(name, *path)
          configuration_directory(name).join(*path.map(&:to_s))
        end

        # @return [Pathname]
        def state_directory(name)
          workspace_path(name, :state)
        end

        def state_path(name, *path)
          state_directory(name).join(*path.map(&:to_s))
        end
      end
    end
  end
end
