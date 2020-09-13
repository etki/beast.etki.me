module Etki
  module Satellite
    class Registry
      class Paths
        def initialize(configuration)
          @configuration = configuration
        end

        def workspace
          fallback = "/var/#{default_directory_name}"
          Pathname.new(@configuration[:workspace] || fallback)
        end

        def configuration
          fallback = "/etc/#{default_directory_name}"
          Pathname.new(@configuration[:configuration] || fallback)
        end

        private

        def default_directory_name
          "#{Constants.organization}/#{Constants.project}"
        end
      end
    end
  end
end
