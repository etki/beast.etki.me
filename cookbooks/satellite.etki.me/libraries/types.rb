module Etki
  module Satellite
    module Types
      class << self
        def examine(value, *variables)
          representation = "#<#{value.class}"

          variables = variables.map { |name| "@#{name.to_s.delete_prefix('@')}" }
          variables = value.instance_variables if variables.empty?
          properties = variables.map do |name|
            "#{name}=#{value.instance_variable_get(name).inspect}"
          end

          representation = representation + ': ' + properties.join(', ') unless properties.empty?
          representation + '>'
        end
      end
    end
  end
end
