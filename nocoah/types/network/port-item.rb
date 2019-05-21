require_relative '../base'
require_relative '../../utility'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Port item
            class PortItem < Base

                # @return [String] Port ID
                attr_reader :port_id
                # @return [String] Port name
                attr_reader :name
                # @return [String (Nocoah::Types::Network::Status)] Status
                attr_reader :status
                # @return [Array<Nocoah::Types::Network::FixedIPAddress>] Fixed IP addresses with subnet IDs
                attr_reader :fixed_ips
                # @return [Array<String>] Security group IDs
                attr_reader :security_groups
                # @return [String] Mac address
                attr_reader :mac_address
                # @return [String] Binding VNIC type
                attr_reader :binding__vnic_type
                # @return [String] Network ID
                attr_reader :network_id
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [String] Device ID
                attr_reader :device_id
                # @return [String] Device owner
                attr_reader :device_owner
                # @return [Boolean] Administrative state of the network
                attr_reader :admin_state_up
                # @return [Array<Hash>] Allowed address pairs
                attr_reader :allowed_address_pairs
                # @return [Array<Hash>] Extra DHCP options
                attr_reader :extra_dhcp_opts

                # Creates a new {PortItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @port_id = data['id']
                    @name = data['name']
                    @status = data['status']
                    @fixed_ips = data['fixed_ips'].map { | ip | FixedIPAddress.new( ip ) } rescue []
                    @security_groups = data['security_groups']
                    @mac_address = data['mac_address']
                    @binding__vnic_type = data['binding:vnic_type']
                    @network_id = data['network_id']
                    @tenant_id = data['tenant_id']
                    @device_id = data['device_id']
                    @device_owner = data['device_owner']
                    @admin_state_up = Utility.to_b( data['admin_state_up'] )
                    @allowed_address_pairs = data['allowed_address_pairs']
                    @extra_dhcp_opts = data['extra_dhcp_opts']
                end

            end

        end

    end

end