require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Order item
            class OrderItem < Base

                # @return [String] Order item unique ID
                attr_reader :uu_id
                # @return [String] Service name
                attr_reader :service_name
                # @return [DateTime] Service start date
                attr_reader :service_start_date
                # @return [String] Item status
                attr_reader :item_status

                # Creates a new {OrderItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @uu_id = data['uu_id'] rescue nil
                    @service_name = data['service_name'] rescue nil
                    @service_start_date = DateTime.parse( data['service_start_date'] ) rescue nil
                    @item_status = data['item_status'] rescue nil
                end

            end

            # Sort key of Domain
            module SortKeyOrderItem
                # Sort by Service start date
                SERVICE_START_DATE = "service_start_date"
                # Sort by Service name
                SERVICE_NAME = "service_name"
                # Sort by Item status
                ITEM_STATUS = "item_status"

                # Validates a key name
                #
                # @param [String] key_name      Sort key name
                #
                # @return [True]    key_name is valid.
                # @return [False]   key_name is invalid.
                def self.validate_key( key_name )
                    key_name == SERVICE_START_DATE || key_name == SERVICE_NAME || key_name == ITEM_STATUS
                end
            end

        end
    
    end

end