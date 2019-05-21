require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Loadbalancer associated pool item
            class AssociatedPoolItem < Base

                # @return [String] Pool ID
                attr_reader :pool_id
                # @return [String] Status
                attr_reader :status
                # @return [String] Status description
                attr_reader :status_description

                # Creates a new {AssociatedPoolItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @pool_id = data['pool_id']
                    @status = data['status']
                    @status_description = data['status_description']
                end

            end

        end

    end

end