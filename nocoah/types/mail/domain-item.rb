require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Domain item
            class DomainItem < Base

                # @return [String] Domain ID
                attr_reader :domain_id
                # @return [String] Domain name
                attr_reader :domain_name
                # @return [String] Service ID
                attr_reader :service_id
                # @return [String] DKIM enabled
                attr_reader :dkim_enabled

                # Creates a new {DomainItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @domain_id = data['domain_id']
                    @domain_name = data['domain_name']
                    @service_id = data['service_id']
                    @dkim_enabled = data['dkim']
                end

            end

            # Sort key of Domain
            module SortKeyDomain
                # Sort by Created date
                CREATE_DATE = "create_date"
                # Sort by Domain name
                DOMAIN_NAME = "domain_name"
            end
            
        end

    end

end