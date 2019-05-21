Dir["#{File.dirname( __FILE__ )}/network/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Status
            module Status
                # @return [String] Active
                ACTIVE = "ACTIVE"
                # @return [String] Down
                DOWN = "DOWN"
                # @return [String] Build
                BUILD = "BUILD"
                # @return [String] Error
                ERROR = "ERROR"
            end
            
        end

    end

end