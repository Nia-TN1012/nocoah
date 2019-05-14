require 'date'
require_relative '../common'
require_relative './fixed-ip-address'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Attached interface item
            class AttachedInterfaceItem

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

                def initialize( data )
                    if data.key?( 'fixed_ips' )
                        @fixed_ips = data['fixed_ips'].map do | ip |
                            FixedIPAddress.new( ip )
                        end
                    else
                        @fixed_ips = []
                    end
                    @mac_addr = data['mac_addr']
                    @net_id = data['net_id']
                    @port_id = data['port_id']
                    @port_state = data['port_state']
                end

                def to_s
                    {
                        'Fixed IP addresses with subnet IDs' => @fixed_ips.map { | ip | ip.to_s },
                        'MAC address' => @mac_addr,
                        'Network ID' => @net_id,
                        'Port ID' => @port_id,
                        'Port status' => @port_state,
                    }.to_s
                end

            end

        end

    end

end