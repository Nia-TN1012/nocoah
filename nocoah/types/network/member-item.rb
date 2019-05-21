require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Loadbalancer member item
            class MemberItem < Base

                # @return [String] Member ID
                attr_reader :member_id
                # @return [String (Nocoah::Types::Network::Status)] Status
                attr_reader :status
                # @return [String] Status description
                attr_reader :status_description
                # @return [Integer] Weight
                attr_reader :weight
                # @return [String] IP address
                attr_reader :address
                # @return [Integer] Protocol port
                attr_reader :protocol_port
                # @return [String] Pool ID
                attr_reader :pool_id
                # @return [String] Tenant ID
                attr_reader :tenant_id

                # Creates a new {MemberItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @member_id = data['member_id']
                    @status = data['status']
                    @status_description = data['status_description']
                    @weight = data['weight']
                    @address = data['address']
                    @protocol_port = data['protocol_port']
                    @subnet_id = data['subnet_id']
                    @tenant_id = data['tenant_id']
                end

            end

        end

    end

end