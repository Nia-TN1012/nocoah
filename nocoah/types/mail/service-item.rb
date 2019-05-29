require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # Service item
            class ServiceItem < Base

                # @return [String] Service ID
                attr_reader :service_id
                # @return [String] Service name
                attr_reader :service_name
                # @return [String] Status
                attr_reader :status
                # @return [String] SMTP hostname
                attr_reader :smtp
                # @return [String] POP hostname
                attr_reader :pop
                # @return [String] IMAP hostname
                attr_reader :imap
                # @return [String] MX hostname
                attr_reader :mx
                # @return [Integer] Quota (GB)
                attr_reader :quota
                # @return [Float] Total usage (GB)
                attr_reader :total_usage
                # @return [String] Default domain
                attr_reader :default_domain
                # @return [String] Backup enabled
                attr_reader :backup
                # @return [Hash] Backup IMAP hostname ( keys: 1day_ago, 2day_ago, 3day_ago )
                attr_reader :backup_imap
                # @return [Hash] Metadata
                attr_reader :metadata
                # @return [DateTime] Created time
                attr_reader :create_date

                # Creates a new {ServiceItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @service_id = data['service_id']
                    @service_name = data['service_name']
                    @status = data['status']
                    @smtp = data['smtp']
                    @pop = data['pop']
                    @imap = data['imap']
                    @mx = data['mx']
                    @quota = data['quota']
                    @total_usage = data['total_usage']
                    @default_domain = data['default_domain']
                    @backup = data['backup']
                    @backup_imap = data['backup_imap']
                    @metadata = data['metadata']
                    @create_date = DateTime.parse( data['create_date'] ) rescue nil
                end

            end

            # Sort key of Service
            module SortKeyService
                # Sort by Created date
                CREATE_DATE = "create_date"
                # Sort by Service name
                SERVICE_NAME = "service_name"
                # Sort by Status
                STATUS = "status"
            end
            
        end

    end

end