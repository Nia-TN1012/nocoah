require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Account
        module Account

            # Notification item
            class NotificationItem < Base

                # @return [Integer] Notification code
                attr_reader :notification_code
                # @return [String] Title
                attr_reader :title
                # @return [String] Notification type
                attr_reader :type
                # @return [String] Contents
                attr_reader :contents
                # @return [String] Read status ( There is {Nocoah::Types::Account::ReadStatus} as an alias. )
                attr_reader :read_status
                # @return [DateTime] Publishd date
                attr_reader :start_date

                # Creates a new {BillingInvoiceItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @notification_code = data['notification_code']
                    @title = data['title']
                    @type = data['type']
                    @contents = data['contents']
                    @read_status = data['read_status']
                    @start_date = DateTime.parse( data['start_date'] ) rescue nil
                end

            end

        end

    end

end