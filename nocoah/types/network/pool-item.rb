require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Loadbalancer pool item
            class PoolItem < Base

                # @return [String] Pool ID
                attr_reader :pool_id
                # @return [String] Pool name
                attr_reader :name
                # @return [String] Status
                attr_reader :status
                # @return [String] Loadbalancer method
                attr_reader :lb_method
                # @return [String] Protocol
                attr_reader :protocol
                # @return [String] Description
                attr_reader :description
                # @return [String] Status description
                attr_reader :status_description
                # @return [Array<String>] Member IDs connected to loadbalancer
                attr_reader :members
                # @return [Array<String>] Health monitor IDs
                attr_reader :health_monitors
                # @return [String] VIP ID
                attr_reader :vip_id
                # @return [String] Subnet ID
                attr_reader :subnet_id
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [Boolean] Administrative state of the network
                attr_reader :admin_state_up
                # @return [String] Provider
                attr_reader :provider

                # Creates a new {PoolItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @pool_id = data['id']
                    @name = data['name']
                    @status = data['status']
                    @lb_method = data['lb_method']
                    @protocol = data['protocol']
                    @description = data['description']
                    @status_description = data['status_description']
                    @members = data['members']
                    @health_monitors = data['health_monitors']
                    @vip_id = data['vip_id']
                    @subnet_id = data['subnet_id']
                    @tenant_id = data['tenant_id']
                    @admin_state_up = data['admin_state_up']
                    @provider = data['provider']
                end

            end

        end

    end

end