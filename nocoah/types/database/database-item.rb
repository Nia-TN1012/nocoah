require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # Database item
            class DatabaseItem < Base

                # @return [String] Database ID
                attr_reader :database_id
                # @return [String] Service ID
                attr_reader :service_id
                # @return [String] Internal hostname
                attr_reader :internal_hostname
                # @return [String] External hostname
                # @note Hostname when connecting with mysql client from external network.
                # @example Connects database from mysql client.
                #   $ mysql -h{external_hostname} -u{user} -p{pass} -D{db_name}
                attr_reader :external_hostname
                # @return [String] Database name
                attr_reader :db_name
                # @return [Float] Database size (GB)
                attr_reader :db_size
                # @return [String] Memo
                attr_reader :memo
                # @return [String] Database type
                attr_reader :type
                # @return [String] Database character set
                attr_reader :charset
                # @return [String] Status
                attr_reader :status

                # Creates a new {DatabaseItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @database_id = data['database_id']
                    @service_id = data['service_id']
                    @internal_hostname = data['internal_hostname']
                    @external_hostname = data['external_hostname']
                    @db_name = data['db_name']
                    @db_size = data['db_size']
                    @memo = data['memo']
                    @type = data['type']
                    @charset = data['charset']
                    @status = data['status']
                end

            end

            # Sort key of Database
            module SortKeyDatabase
                # Sort by Created date
                CREATE_DATE = "create_date"
                # Sort by Database name
                DB_NAME = "db_name"
                # Sort by Status
                STATUS = "status"
                # Sort by Memo
                MEMO = "memo"
            end

            # Database type
            module DatabaseType
                # MySQL
                MYSQL = "mysql"
            end

            # Database charcter set
            module DatabaseCharacterSet
                # UTF-8
                UTF8 = "utf8"
            end
            
        end

    end

end