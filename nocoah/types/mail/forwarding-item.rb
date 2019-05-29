require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Forwarding item
            class ForwardingItem < Base

                # @return [String] Forwarding ID
                attr_reader :forwarding_id
                # @return [String] Email ID
                attr_reader :email_id
                # @return [String] Forwarding mail address
                attr_reader :forward_mail_address

                # Creates a new {ForwardingItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @forwarding_id = data['forwarding_id']
                    @email_id = data['email_id']
                    @forward_mail_address = data['address']
                end

            end

            # Sort key of Forwarding
            module SortKeyForwarding
                # Sort by Created date
                CREATE_DATE = "create_date"
                # Sort by Forwarding mail address
                ADDRESS = "address"
            end
            
        end

    end

end