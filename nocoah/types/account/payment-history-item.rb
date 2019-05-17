require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Payment history item
            class PaymentHistoryItem < Base

                # @return [String] Money type (e.q. CreditCard, OnlineCVS, PayEasy, etc.)
                attr_reader :money_type
                # @return [Integer] Deposit amout
                attr_reader :deposit_amount
                # @return [DateTime] Recieved date
                attr_reader :received_date

                # Creates a new {PaymentHistoryItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @money_type = data['money_type']
                    @deposit_amount = data['deposit_amount']
                    @received_date = DateTime.parse( data['received_date'] ) rescue nil
                end

            end

        end

    end

end