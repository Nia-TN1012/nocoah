require_relative '../common'
require_relative './fixed-ip-address'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Attached interface item
            class AttachedInterfaceItem < Base

                # @return [Array<Nocoah::Types::Compute::FixedIPAddress>] Fixed IP addresses with subnet IDs
                attr_reader :fixed_ips
                # @return [String] MAC address
                attr_reader :mac_addr
                # @return [String] Network ID
                attr_reader :net_id
                # @return [String] Port ID
                attr_reader :port_id
                # @return [String] Port status
                attr_reader :port_state

                # Creates a new {AttachedInterfaceItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @fixed_ips = data['fixed_ips'].map { | ip | FixedIPAddress.new( ip ) } rescue []
                    @mac_addr = data['mac_addr']
                    @net_id = data['net_id']
                    @port_id = data['port_id']
                    @port_state = data['port_state']
                end

            end

        end

    end

end