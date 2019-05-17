require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Fixed IP address
            class FixedIPAddress < Base

                # @return [String] IP address
                attr_reader :ip_address
                # @return [String] Subnet ID
                attr_reader :subnet_id

                # Creates a new {FixedIPAddress} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @ip_address = data['ip_address']
                    @subnet_id = data['subnet_id']
                end

            end

        end

    end

end