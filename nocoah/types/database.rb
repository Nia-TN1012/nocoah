Dir["#{File.dirname( __FILE__ )}/database/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # Status
            module Status
                # Active
                ACTIVE = "active"
                # Pending
                PENDING = "pending"
                # Creating
                CREATING = "creating"
                # Deleting
                DELETING = "deleting"
                # Error
                ERROR = "error"
            end
            
        end

    end

end