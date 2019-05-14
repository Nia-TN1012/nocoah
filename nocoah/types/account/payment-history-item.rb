require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Payment history item
            class PaymentHistoryItem

                # @return [String] Money type (e.q. CreditCard, OnlineCVS, PayEasy, etc.)
                attr_reader :money_type
                # @return [Integer] Deposit amout
                attr_reader :deposit_amount
                # @return [DateTime] Recieved date
                attr_reader :received_date

                def initialize( data )
                    @money_type = data['money_type']
                    @deposit_amount = data['deposit_amount']
                    @received_date = DateTime.parse( data['received_date'] ) rescue nil
                end

                def to_s
                    {
                        'Money type' => @money_type,
                        'Depposit amount' => @deposit_amount,
                        'Recieved date' => @received_date
                    }.to_s
                end

            end

        end

    end

end