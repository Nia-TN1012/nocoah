require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Server address item
            class ServerAddressItem < Base

                # @return [String] Mac address
                attr_reader :mac_address
                # @return [String] Type
                attr_reader :type
                # @return [String] IP address
                attr_reader :ip_address
                # @return [Integer] Version
                attr_reader :version

                # Creates a new {ServerAddressItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @mac_address = data['OS-EXT-IPS-MAC:mac_addr']
                    @type = data['OS-EXT-IPS:type']
                    @ip_address = data['addr']
                    @version = data['version']
                end

            end

        end

    end

end