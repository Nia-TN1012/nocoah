Dir["#{File.dirname( __FILE__ )}/account/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

             # Read status of notification
             module ReadStatus
                # Unread
                UNREAD = "Unread"
                # Read title only
                READ_TITLE_ONLY = "ReadTitleOnly"
                # Read
                READ = "Read"
            end

        end

    end

end