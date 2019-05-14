require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Payment summary
            class PaymentSummary

                # @return [Integer] Total deposit amount
                attr_reader :total_deposit_amount

                def initialize( data )
                    @total_deposit_amount = data['total_deposit_amount']
                end

                def to_s
                    {
                        'Total deposit amount' => @total_deposit_amount
                    }.to_s
                end

            end

        end

    end

end