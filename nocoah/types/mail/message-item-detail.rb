require_relative './message-item'
require_relative './attachment-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Message item detail
            class MessageItemDetail < MessageItem

                # @return [String] Massage
                attr_reader :message
                # @return [Nocoah::Types::Mail::AttachmentItem] Attachement files
                attr_reader :attachments

                # Creates a new {MessageItemDetail} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    super( data )

                    @message = data['message']
                    @attachments = data['attachments'].map { | attachment | AttachementItem.new( attachment ) } rescue []
                end

            end
            
        end

    end

end