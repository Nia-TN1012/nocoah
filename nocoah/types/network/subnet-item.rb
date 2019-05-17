require_relative '../base'
require_relative './allocation-pool'
require_relative '../../utility'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Subnet item
            class SubnetItem < Base

                # @return [String] Subnet ID
                attr_reader :subnet_id
                # @return [String] Subnet name
                attr_reader :name
                # @return [String] IP version
                attr_reader :ip_version
                # @return [String] IPv6 address mode
                attr_reader :ipv6_address_mode
                # @return [String] IPv6 router advertisement mode
                attr_reader :ipv6_ra_mode
                # @return [String] CIDR
                attr_reader :cidr
                # @return [String] Gateway IP
                attr_reader :gateway_ip
                # @return [Array<Nocoah::Types::Network::AllocationPool>] Allocation pools
                attr_reader :allocation_pools
                # @return [Boolean] Enable DHCP
                attr_reader :enable_dhcp
                # @return [Array<String>] DNS name servers
                attr_reader :dns_nameservers
                # @return [Array<Hash>] Host routes
                attr_reader :host_routes
                # @return [String] Network ID
                attr_reader :network_id
                # @return [String] Tenant ID
                attr_reader :tenant_id

                # Creates a new {SubnetItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @subnet_id = data['id']
                    @name = data['name']
                    @ip_version = data['ip_version']
                    @ipv6_address_mode = data['ipv6_address_mode']
                    @ipv6_ra_mode = data['ipv6_ra_mode']
                    @cidr = data['cidr']
                    @gateway_ip = data['gateway_ip']
                    @allocation_pools = data['allocation_pools'].map { | pool | AllocationPool.new( pool ) } rescue []
                    @enable_dhcp = Utility.to_b( data['enable_dhcp'] )
                    @dns_nameservers = data['dns_nameservers']
                    @host_routes = data['host_routes']
                    @network_id = data['network_id']
                    @tenant_id = data['tenant_id']
                    
                end

            end

        end

    end

end