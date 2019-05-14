require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Billing invoice item
            class BillingInvoiceItem

                # @return [Integer] Invoice ID
                attr_reader :invoice_id
                # @return [String] Payment method type (e.q. Credit, Charge, etc.)
                attr_reader :payment_method_type
                # @return [DateTime] Invoice date
                attr_reader :invoice_date
                # @return [Integer] Billing amount (tax included) (JPY)
                attr_reader :bill_plus_tax
                # @return [DateTime] Payment due date
                attr_reader :due_date

                def initialize( data )
                    @invoice_id = data['invoice_id']
                    @payment_method_type = data['payment_method_type']
                    @invoice_date = DateTime.parse( data['invoice_date'] ) rescue nil
                    @bill_plus_tax = data['bill_plus_tax']
                    @due_date = data['due_date']
                end

                def to_s
                    {
                        'Invoice ID' => @invoice_id,
                        'Payment method type' => @payment_method_type,
                        'Invoice date' => @invoice_date,
                        'Billing amount (tax included)' => @bill_plus_tax,
                        'Payment due date' => @due_date
                    }.to_s
                end

            end

        end

    end

end