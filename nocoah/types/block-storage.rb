require_relative './common'
Dir["#{File.dirname( __FILE__ )}/block-storage/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Block Storage
        module BlockStorage

        end

    end

end