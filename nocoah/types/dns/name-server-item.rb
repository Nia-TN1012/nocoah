require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # DNS
        module DNS

            # Name server item
            class NameServerItem < Base

                # @return [String] Name server ID
                attr_reader :name_server_id
                # @return [String] Name server hostname
                attr_reader :name
                # @return [DateTime] Created Time
                attr_reader :created_at
                # @return [DateTime] Updated Time
                attr_reader :updated_at

                # Creates a new {DomainItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @name_server_id = data['id']
                    @name = data['name']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @updated_at = DateTime.parse( data['updated_at'] ) rescue nil
                end

            end
            
        end

    end

end