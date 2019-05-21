require_relative '../base'
require_relative './security-group-rule'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Security group item
            class SecurityGroupItem < Base

                # @return [String] Security group ID
                attr_reader :security_group_id
                # @return [String] Security group name
                attr_reader :name
                # @return [String] Description
                attr_reader :description
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [Array<Nocoah::Types::Network::SecurityGroupRule>] Rules
                attr_reader :security_group_rules

                # Creates a new {SecurityGroupItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @security_group_id = data['id']
                    @name = data['name']
                    @description = data['description']
                    @tenant_id = data['tenant_id']
                    @security_group_rules = data['security_group_rules'].map { | rule | SecurityGroupRule.new( rule ) } rescue [] 
                end

            end

        end

    end

end