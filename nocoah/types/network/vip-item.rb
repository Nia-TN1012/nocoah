require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Loadbalancer vip item
            class VIPItem < Base

                # @return [String] VIP ID
                attr_reader :vip_id
                # @return [String] VIP name
                attr_reader :name
                # @return [String] Status
                attr_reader :status
                # @return [String] Protocol
                attr_reader :protocol
                # @return [String] IP address
                attr_reader :address
                # @return [String] Protocol port
                attr_reader :protocol_port
                # @return [String] Port ID
                attr_reader :port_id
                # @return [String] Description
                attr_reader :description
                # @return [String] Status description
                attr_reader :status_description
                # @return [String] Subnet ID
                attr_reader :subnet_id
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [Integer] Connection limit ( When -1, unlimited )
                attr_reader :connection_limit
                # @return [Boolean] Administrative state of the network
                attr_reader :admin_state_up
                # @return [String] Session persistence
                attr_reader :session_persistence

                # Creates a new {VIPItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @vip_id = data['vip_id']
                    @name = data['name']
                    @status = data['status']
                    @protocol = data['protocol']
                    @address = data['address']
                    @protocol_port = data['protocol_port']
                    @port_id = data['port_id']
                    @description = data['description']
                    @status_description = data['status_description']
                    @vip_id = data['vip_id']
                    @subnet_id = data['subnet_id']
                    @tenant_id = data['tenant_id']
                    @connection_limit = data['connection_limit']
                    @admin_state_up = data['admin_state_up']
                    @session_persistence = data['session_persistence']
                end

            end

        end

    end

end