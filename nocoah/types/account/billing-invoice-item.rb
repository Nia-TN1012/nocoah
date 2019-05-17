require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Billing invoice item
            class BillingInvoiceItem < Base

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

                # Creates a new {BillingInvoiceItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @invoice_id = data['invoice_id']
                    @payment_method_type = data['payment_method_type']
                    @invoice_date = DateTime.parse( data['invoice_date'] ) rescue nil
                    @bill_plus_tax = data['bill_plus_tax']
                    @due_date = data['due_date']
                end

            end

        end

    end

end