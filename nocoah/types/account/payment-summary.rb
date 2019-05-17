require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Payment summary
            class PaymentSummary < Base

                # @return [Integer] Total deposit amount
                attr_reader :total_deposit_amount

                # Creates a new {PaymentSummary} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @total_deposit_amount = data['total_deposit_amount']
                end

            end

        end

    end

end