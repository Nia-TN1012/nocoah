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
                # No state
                NOSTATE = 0
                # Running
                RUNNING = 1
                # Paused
                PAUSED = 3
                # Shutdown
                SHUTDOWN = 4
                # Crashed
                CRASHED = 6
                # Suspended
                SUSPENDED = 7
            end

        end

    end

end