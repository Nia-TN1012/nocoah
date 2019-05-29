require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Attachement item
            class AttachementItem < Base

                # @return [String] Attachement ID
                attr_reader :attachment_id
                # @return [String] Attachement file name
                attr_reader :file_name
                # @return [String] Content type
                attr_reader :content_type
                # @return [String (binary)] Attachement file
                attr_reader :attachment_file

                # Creates a new {AttachementItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @attachment_id = data['attachment_id']
                    @file_name = data['attachment_file_name']
                    @content_type = data['content_type']
                    @attachment_file = data['attachment_file']
                end

            end
            
        end

    end

end