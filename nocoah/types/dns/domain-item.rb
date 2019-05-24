require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # DNS
        module DNS

            # Domain item
            class DomainItem < Base

                # @return [String] Domain ID
                attr_reader :domain_id
                # @return [String] Domain name
                attr_reader :name
                # @return [DateTime] Created Time
                attr_reader :created_at
                # @return [DateTime] Updated Time
                attr_reader :updated_at
                # @return [String] Email address
                attr_reader :email
                # @return [Integer] TTL
                attr_reader :ttl
                # @return [Integer] Serial number
                attr_reader :serial
                # @return [String] Remarks
                attr_reader :description
                # @return [Integer] Enabled GSLB
                attr_reader :gslb

                # Creates a new {DomainItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @domain_id = data['id']
                    @name = data['name']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @updated_at = DateTime.parse( data['updated_at'] ) rescue nil
                    @email = data['email']
                    @ttl = data['ttl']
                    @serial = data['serial']
                    @description = data['description']
                    @gslb = data['gslb']
                end

            end
            
        end

    end

end