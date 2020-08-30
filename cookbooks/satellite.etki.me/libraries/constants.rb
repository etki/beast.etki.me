module Etki
  module Satellite
    module Constants
      class << self
        def organization
          'etki.me'
        end

        def project
          'satellite.etki.me'
        end

        def name(*chunks, separator: ':')
          ([organization, project] + chunks).join(separator)
        end
      end
    end
  end
end
