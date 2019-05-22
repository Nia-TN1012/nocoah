require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # Grant user
            class GrantUser < Base

                # @return [String] User ID
                attr_reader :user_id
                # @return [String] Status
                attr_reader :status

                # Creates a new {GrantUser} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @user_id = data['user_id']
                    @status = data['status']
                end

            end
            
        end

    end

end