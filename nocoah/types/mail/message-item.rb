require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Message item
            class MessageItem < Base

                # @return [String] Message ID
                attr_reader :message_id
                # @return [String] Sender email address
                attr_reader :sender_email_address
                # @return [String] Subject
                attr_reader :subject
                # @return [Integer] Message size
                attr_reader :size
                # @return [DateTime] Recieved date
                attr_reader :recieved_date

                # Creates a new {MessageItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @message_id = data['message_id']
                    @sender_email_address = data['from']
                    @subject = data['subject']
                    @size = data['size']
                    @recieved_date = DateTime.parse( data['date'] ) rescue nil
                end

            end

            # Sort key of Message
            module SortKeyMessage
                # Sort by recieved date
                DATE = "date"
                # Sort by subject
                SUBJECT = "subject"
                # Sort by sender email address
                FROM = "from"
            end
            
        end

    end

end