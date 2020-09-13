module Etki
  module Satellite
    class Registry
      class Machine
        def initialize(configuration, context)
          @configuration = configuration
          @context = context
        end

        def name
          @configuration[:name]
        end

        def domain
          @configuration[:domain]
        end

        def advertised_name
          "#{name}.#{domain}"
        end

        def local_address_specifications
          default_interface = @context[:network, :default_interface]
          address_list = @context[:network, :interfaces, default_interface, :addresses]

          address_list
            .select { |_, specification| specification['scope'] == 'Global' }
            .map { |address, specification| specification.dup.update('address' => address) }
        end

        def local_address_specification
          local_address_specifications.first
        end

        def local_ipv4_address_specifications
          local_address_specifications.select { |address| address['family'] == 'inet' }
        end

        def local_ipv4_address_specification
          local_ipv4_address_specifications.first
        end

        def local_ipv6_address_specifications
          local_address_specifications.select { |address| address['family'] == 'inet6' }
        end

        def local_ipv6_address_specification
          local_ipv6_address_specifications.first
        end

        def local_address
          local_address_specification&.fetch('address', nil)
        end

        def local_ipv4_address
          local_ipv4_address_specification&.fetch('address', nil)
        end

        def local_ipv6_address
          local_ipv6_address_specification&.fetch('address', nil)
        end
      end
    end
  end
end
