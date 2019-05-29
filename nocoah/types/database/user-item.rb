require_relative './grant-database'

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # User item
            class UserItem < Base

                # @return [String] User ID
                attr_reader :user_id
                # @return [String] User name
                attr_reader :user_name
                # @return [String] Service ID
                attr_reader :service_id
                # @return [String] Status
                attr_reader :status
                # @return [String] Hostname
                attr_reader :hostname
                # @return [Array<Nocoah::Types::Database::GrantDatabase>] Granted databases.
                attr_reader :databases
                # @return [String] Memo
                attr_reader :memo

                # Creates a new {UserItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @user_id = data['user_id']
                    @user_name = data['user_name']
                    @service_id = data['service_id']
                    @status = data['status']
                    @hostname = data['hostname']
                    @databases = data['databases'].map { | db | GrantDatabase.new( db ) } rescue []
                    @memo = data['memo']
                end

            end

            # Sort key of User
            module SortKeyUser
                # Sort by Created date
                CREATE_DATE = "create_date"
                # Sort by User name
                USER_NAME = "user_name"
                # Sort by Status
                STATUS = "status"
                # Sort by Memo
                MEMO = "memo"
                # Sort by Hostname
                HOSTNAME = "hostname"
            end
            
        end

    end

end