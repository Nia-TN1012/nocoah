require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Webhook item
            class WebhookItem < Base

                # @return [String] Webhook URL
                attr_reader :url
                # @return [String] Webhook keyword
                attr_reader :keyword

                # Creates a new {WebhookItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @url = data['webhook_url']
                    @keyword = data['webhook_keyword']
                end

            end
            
        end

    end

end