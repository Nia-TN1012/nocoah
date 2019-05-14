require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Billing invoice detail
            class BillingInvoiceDetailItem

                # @return [Integer] Invoice detail ID
                attr_reader :invoice_detail_id
                # @return [String] Product name
                attr_reader :product_name
                # @return [Float] Unit price (JPY)
                attr_reader :unit_price
                # @return [Integer] Quantitiy
                attr_reader :quantity
                # @return [DateTime] Start date
                attr_reader :start_date
                # @return [DateTime] End date
                attr_reader :end_date

                def initialize( data )
                    @invoice_detail_id = data['invoice_detail_id']
                    @product_name = data['product_name']
                    @unit_price = data['unit_price']
                    @quantity = data['quantity']
                    @start_date = DateTime.parse( data['start_date'] ) rescue nil
                    @end_date = DateTime.parse( data['end_date'] ) rescue nil
                end

                def to_s
                    {
                        'Invoice detail ID' => @invoice_detail_id,
                        'Product name' => @product_name,
                        'Unit price' => @unit_price,
                        'Quantitiy' => @quantity,
                        'Start date' => @start_date,
                        'End date' => @end_date
                    }.to_s
                end

            end

        end

    end

end