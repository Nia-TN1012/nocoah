require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Order item detail
            class OrderItemDetail

                # @return [String] Order item unique ID
                attr_reader :uu_id
                # @return [String] Service name
                attr_reader :service_name
                # @return [String] Product name
                attr_reader :product_name
                # @return [String] Status
                attr_reader :status
                # @return [Float] Unit price (JPY)
                attr_reader :unit_price
                # @return [DateTime] Service start date
                attr_reader :service_start_date
                # @return [DateTime] Billing start date
                attr_reader :bill_start_date
                # @return [DateTime] Cancel date
                attr_reader :cancel_date

                def initialize( data )
                    @uu_id = data['uu_id']
                    @service_name = data['service_name']
                    @product_name = data['product_name']
                    @status = data['status']
                    @unit_price = data['unit_price']
                    @service_start_date = DateTime.parse( data['service_start_date'] ) rescue nil
                    @bill_start_date = data['bill_start_date']
                    @cancel_date = DateTime.parse( data['cancel_date'] ) rescue nil
                end

                def to_s
                    {
                        'UUID' => @uu_id,
                        'Service name' => @service_name,
                        'Product name' => @product_name,
                        'Status' => @status,
                        'Unit price' => @unit_price,
                        'Service start date' => @service_start_date,
                        'Billing start date' => @bill_start_date,
                        'Cancel date' =>  @cancel_date
                    }.to_s
                end

            end

        end

    end

end