require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Order item
            class OrderItem

                # @return [String] Order item unique ID
                attr_reader :uu_id
                # @return [String] Service name
                attr_reader :service_name
                # @return [DateTime] Service start date
                attr_reader :service_start_date
                # @return [String] Item status
                attr_reader :item_status

                
                def initialize( data )
                    @uu_id = data['uu_id'] rescue nil
                    @service_name = data['service_name'] rescue nil
                    @service_start_date = DateTime.parse( data['service_start_date'] ) rescue nil
                    @item_status = data['item_status'] rescue nil
                end

                
                def to_s
                    {
                        'UUID' => @uu_id,
                        'Service name' => @service_name,
                        'Service start date' => @service_start_date,
                        'Item status' => @item_status
                    }.to_s
                end

            end

        end
    
    end

end