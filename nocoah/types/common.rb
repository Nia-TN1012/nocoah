Dir["#{File.dirname( __FILE__ )}/common/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Common
        module Common

            # Data integration method
            module RRDMode
                # Average
                AVERAGE = "average"
                # Max
                MAX = "max"
                # Min
                MIN = "min"
            end

        end

    end

end