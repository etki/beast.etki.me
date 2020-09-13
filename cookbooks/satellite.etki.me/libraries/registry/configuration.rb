module Etki
  module Satellite
    class Registry
      class Configuration
        attr_reader :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        def attribute(*path)
          path.reduce(attributes) do |cursor, segment|
            cursor.nil? ? nil : cursor[segment.to_s]
          end
        end

        alias value attribute

        alias [] attribute

        def traverse(*path)
          Configuration.new(attribute(*path))
        end

        def traverse!(*path)
          node = attribute(*path)
          if node.nil?
            raise "Failed to find configuration node by path #{path}"
          end
          Configuration.new(node)
        end
      end
    end
  end
end
