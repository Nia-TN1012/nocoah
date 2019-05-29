require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Email item
            class EmailItem < Base

                # @return [String] Email ID
                attr_reader :email_id
                # @return [String] Email address
                attr_reader :email
                # @return [String] Domain ID
                attr_reader :domain_id
                # @return [String] User name
                attr_reader :username
                # @return [Boolean] Virus check enabled
                attr_reader :virus_check
                # @return [Boolean] Spam filter enabled
                attr_reader :spam_filter
                # @return [String] Spam filter type
                attr_reader :spam_filter_type
                # @return [Boolean] Whether to leave forwarded mail in inbox
                attr_reader :forwarding_copy
                # @return [String] DKIM
                attr_reader :dkim

                # Creates a new {MailAddressItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @email_id = data['email_id']
                    @email = data['email']
                    @domain_id = data['domain_id']
                    @username = data['username']
                    @virus_check = Utility.to_b( data['virus_check'] )
                    @spam_filter = Utility.to_b( data['spam_filter'] )
                    @spam_filter_type = data['spam_filter_type']
                    @forwarding_copy = Utility.to_b( data['forwarding_copy'] )
                    @dkim = data['dkim']
                end

            end

            # Sort key of Email
            module SortKeyEmail
                # Sort by Created date
                CREATE_DATE = "create_date"
                # Sort by Mail address
                EMAIL = "email"
            end

            # Spam filter type
            module SpamFilterType
                # Pre-appends "[spam]" to the subject of spam email.
                SUBJECT = "subject"
                # Moves spam emails to a dedicated directory.
                TRAY = "tray"
            end
            
        end

    end

end