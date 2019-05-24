require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # Grant database
            class GrantDatabase < Base

                # @return [String] User ID
                attr_reader :database_id
                # @return [String] Status
                attr_reader :db_name

                # Creates a new {GrantDatabase} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @database_id = data['database_id']
                    @status = data['status']
                end

            end
            
        end

    end

end