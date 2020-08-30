module Etki
  module Satellite
    class Registry
      class Containers
        def initialize(configuration, machine)
          @configuration = configuration
          @machine = machine
        end

        def network_name
          @configuration[:network, :name]
        end

        def qualified_network_name
          "#{network_name}.local.#{@machine.advertised_name}"
        end

        def tag(image)
          @configuration[:images, image, :tag] || 'latest'
        end
      end
    end
  end
end
