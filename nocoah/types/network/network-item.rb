require_relative '../base'
require_relative '../../utility'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Network item
            class NetworkItem < Base

                # @return [String] Network ID
                attr_reader :network_id
                # @return [String] Network name
                attr_reader :name
                # @return [String] Status
                attr_reader :status
                # @return [Array<String>] Subnet IDs
                attr_reader :subnets
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [Boolean] Shared
                attr_reader :shared
                # @return [Boolean] Administrative state of the network
                attr_reader :admin_state_up
                # @return [Boolean] External routing
                attr_reader :router__external

                # Creates a new {NetworkItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @network_id = data['id']
                    @name = data['name']
                    @status = data['status']
                    @subnets = data['subnets']
                    @tenant_id = data['tenant_id']
                    @shared = Utility.to_b( data['shared'] )
                    @admin_state_up = Utility.to_b( data['admin_state_up'] )
                    @router__external = Utility.to_b( data['router:external'] )
                end

            end

        end

    end

end