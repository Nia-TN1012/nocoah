require_relative './common'
Dir["#{File.dirname( __FILE__ )}/compute/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Power state
            module PowerState

                NOSTATE = 0
                RUNNING = 1
                PAUSED = 3
                SHUTDOWN = 4
                CRASHED = 6
                SUSPENDED = 7

            end

        end

    end

end