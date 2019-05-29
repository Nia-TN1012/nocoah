require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # Service item
            class ServiceItem < Base

                # @return [String] Service ID
                attr_reader :service_id
                # @return [String] Service name
                attr_reader :service_name
                # @return [DateTime] Created time
                attr_reader :create_date
                # @return [Integer] Quota (GB)
                attr_reader :quota
                # @return [Float] Total usage (GB)
                attr_reader :total_usage
                # @return [String] Status
                attr_reader :status
                # @return [String] Backup enabled
                attr_reader :backup
                # @return [String] Prefix
                attr_reader :prefix
                # @return [Hash] Metadata
                attr_reader :metadata

                # Creates a new {ServiceItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @service_id = data['service_id']
                    @service_name = data['service_name']
                    @create_date = DateTime.parse( data['create_date'] ) rescue nil
                    @quota = data['quota']
                    @total_usage = data['total_usage']
                    @status = data['status']
                    @backup = data['backup']
                    @prefix = data['prefix']
                    @metadata = data['metadata']
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