require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/database'

# Nocoah
module Nocoah

    # Client
    module Client

        # Database API
        #
        # @see https://www.conoha.jp/database/
        class Database < Base

            # Database API Endpoint ( '%s' contains a string representing the region. )
            ENDPOINT_BASE = "https://database-hosting.%s.conoha.io/v1"

            # Gets a service list.
            #
            # @param            [Hash]      url_query       URL query         
            # @option url_query [Integer]   :offset         Offset
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Database::SortKeyService}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Database::ServiceItem>]     When succeeded, service list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_service_item
            # @see https://www.conoha.jp/docs/paas-database-list-database-service.html
            def get_service_list( **url_query )
                uri = URI.parse( "/services" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get service list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'services' )

                json_data['services'].map { | service | Types::Database::ServiceItem.new( service ) }
            end

            # Gets a service item.
            #
            # @param [String] service_id    Service ID
            #
            # @return [Nocoah::Types::Database::ServiceItem]    When succeeded, service item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_service_list
            # @see https://www.conoha.jp/docs/paas-database-get-database-service.html
            def get_service_item( service_id )
                json_data = api_get( "/services/#{service_id}", error_message: "Failed to get service item (service_id: #{service_id})." )
                return nil unless json_data.key?( 'service' )

                Types::Database::ServiceItem.new( json_data['service'] )
            end

            # Creates a new service.
            #
            # @param [String]   service_name        Service name
            # @param [Hash]     metadata            Metadata
            #
            # @example
            #   create_service(
            #       "dbservice01",
            #       metadata: {
            #           key: value
            #       }
            #   )
            #
            # @return [Nocoah::Types::Database::ServiceItem]    When succeeded, created service item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-create-database-service.html
            # @see https://www.conoha.jp/vps/pricing/
            def create_service( service_name, metadata: {} )
                json_data = api_post(
                    "/services",
                    body: {
                        service_name: service_name,
                        metadata: metadata
                    },
                    error_message: "Failed to create service (service_name: #{service_name}, metadata: #{metadata})." 
                )
                return nil unless json_data.key?( 'service' )

                Types::Database::ServiceItem.new( json_data['service'] )
            end

            # Updates the service.
            #
            # @param [String]   service_id          Service ID
            # @param [String]   service_name        Service name
            # @param [Hash]     metadata            Metadata
            #
            # @return [Nocoah::Types::Database::ServiceItem]    When succeeded, updated service item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-update-database-service.html
            def update_service( service_id, service_name: nil, metadata: nil )
                body = {}
                body[:service_name] = service_name if !service_name.nil?
                body[:metadata] = metadata if !metadata.nil?
                json_data = api_put(
                    "/services/#{service_id}",
                    body: body,
                    error_message: "Failed to update service (service_id: #{service_id}, service_name: #{service_name}, metadata: #{metadata})." 
                )
                return nil unless json_data.key?( 'service' )

                Types::Database::ServiceItem.new( json_data['service'] )
            end

            # Updates the service metadata.
            #
            # @param [String]   service_id          Service ID
            # @param [Hash]     metadata            Metadata
            #
            # @return [Hash]                When succeeded, updated service metadata.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-update-database-service.html
            def update_service_metadata( service_id, metadata: )
                api_put(
                    "/services/#{service_id}/metadata",
                    body: {
                        metadata: metadata
                    },
                    error_message: "Failed to update service metadata (service_id: #{service_id}, metadata: #{metadata})."
                    )
                json_data['metadata']
            end

            # Deletes the service.
            #
            # @param [String] service_id    Service ID
            #
            # @return [String]              When succeeded, deleted service ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-delete-database-service.html
            def delete_service( service_id )
                api_delete(
                    "/services/#{service_id}/metadata",
                    error_message: "Failed to delete service (service_id: #{service_id})."
                ) do | res |
                    service_id
                end
            end

            # Gets quota and total usage of the service.
            #
            # @param [String] service_id    Service ID
            #
            # @return [Hash]                When succeeded, :quota and :total_usage. 
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see get_service_list
            # @see https://www.conoha.jp/docs/paas-database-get-database-quotas.html
            def get_service_quota( service_id )
                json_data = api_get( "/services/#{service_id}/quotas", error_message: "Failed to get service quota (service_id: #{service_id})." )
                return nil unless json_data.key?( 'quota' )

                json_data['quota']
            end

            # Sets quota of the service.
            #
            # @param [String]   service_id      Service ID
            # @param [Integer]  quota           Quota (GB)
            #
            # @return [Hash]                When succeeded, :quota and :total_usage. 
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-update-database-quotas.html
            # @see https://www.conoha.jp/vps/pricing/
            def set_service_quota( service_id, quota: )
                json_data = api_get(
                    "/services/#{service_id}/quotas",
                    body: {
                        quota: quota
                    },
                    error_message: "Failed to set service quota (service_id: #{service_id})."
                )
                return nil unless json_data.key?( 'quota' )

                json_data['quota']
            end

            # Sets the service backup.
            #
            # @param [String]               service_id      Service ID
            # @param [String or Boolean]    enabled         When "enable" or true, enables backup
            #
            # @return [String]              When succeeded, updated service ID. 
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-update-database-quotas.html
            # @see https://www.conoha.jp/vps/pricing/
            def set_database_backup( service_id, enabled: )
                case enabled
                when TrueClass
                    backup = "enable"
                when FalseClass
                    backup = "disable"
                else
                    backup = enabled
                end
                api_put(
                    "/services/#{service_id}/action",
                    body: {
                        backup: {
                            status: backup
                        }
                    },
                    error_message: "Failed to set database backup (service_id: #{service_id}, enabled: #{enabled})."
                ) do | res |
                    service_id
                end
            end

            # Gets a database list.
            #
            # @param            [Hash]      url_query       URL query
            # @option url_query [String]    :service_id     Filter by service ID      
            # @option url_query [Integer]   :offset         Offset
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Database::SortKeyDatabase}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Database::DatabaseItem>]    When succeeded, database list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_database_item
            # @see https://www.conoha.jp/docs/paas-database-list-database.html
            def get_database_list( **url_query )
                uri = URI.parse( "/databases" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get database list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'databases' )

                json_data['databases'].map { | database | Types::Database::DatabaseItem.new( database ) }
            end

            # Gets a database item.
            #
            # @param [String] database_id       Database ID
            #
            # @return [Nocoah::Types::Database::DatabaseItem]   When succeeded, database item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_service_list
            # @see https://www.conoha.jp/docs/paas-database-get-database.html
            def get_database_item( database_id )
                json_data = api_get( "/databases/#{database_id}", error_message: "Failed to get database item (database_id: #{database_id})." )
                return nil unless json_data.key?( 'database' )

                Types::Database::DatabaseItem.new( json_data['database'] )
            end

            # Creates a new database.
            #
            # @param  [String] service_id       Service ID
            # @param  [String] db_name          Database name
            # @option [String] type             Database type ( It can also be specified from the constant list of {Types::Database::DatabaseType}. )
            # @option [String] charset          Database character set ( It can also be specified from the constant list of {Types::Database::DatabaseCharacterSet}. )
            # @option [String] memo             Memo
            #
            # @example
            #   create_database(
            #       "9d6441f6-c5a0-4dcf-a1a9-1a4d724e51fd",
            #       db_name: "dbname01",
            #       memo: "memo"
            #   )
            #
            # @return [Nocoah::Types::Database::DatabaseItem]   When succeeded, created database item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-create-database.html
            def create_database( service_id, db_name:, type: Types::Database::DatabaseType::MYSQL, charset: Types::Database::DatabaseCharacterSet::UTF8, memo: "" )
                json_data = api_post(
                    "/databases",
                    body: {
                        service_id: service_id,
                        db_name: db_name,
                        type: type,
                        charset: charset,
                        memo: memo
                    },
                    error_message: "Failed to create database (service_id: #{service_id}, db_name: #{db_name}, type: #{type}, charset: #{charset}, memo: #{memo})." 
                )
                return nil unless json_data.key?( 'database' )

                Types::Database::DatabaseItem.new( json_data['database'] )
            end

            # Updates the database.
            #
            # @param          [String]      database_id         Database ID
            # @param          [Hash]        options             Options
            # @option options [String]      :memo               ("") Memo
            #
            # @return [Nocoah::Types::Database::DatabaseItem]   When succeeded, updated database item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-update-database.html
            def update_database( database_id, **options )
                json_data = api_put(
                    "/databases/#{database_id}",
                    body: options,
                    error_message: "Failed to update database (database_id: #{database_id}, options: #{options})." 
                )
                return nil unless json_data.key?( 'database' )

                Types::Database::DatabaseItem.new( json_data['database'] )
            end

            # Deletes the database.
            #
            # @param          [String]      database_id         Database ID
            #
            # @return [String]              When succeeded, deleted database ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-delete-databases.html
            def delete_database( database_id )
                api_delete( 
                    "/databases/#{database_id}",
                    error_message: "Failed to delete database (database_id: #{database_id}."
                ) do | res |
                    database_id
                end
            end

            # Gets a grant list associated the database.
            #
            # @option           [String]    database_id     Database ID
            # @param            [Hash]      url_query       URL query
            # @option url_query [Integer]   :offset         Offset
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Database::SortKeyGrantUser}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Database::GrantUser>]       When succeeded, database grant list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-list-grant.html
            def get_db_grant_list( database_id, **url_query )
                uri = URI.parse( "/databases/#{database_id}/grant" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get database grant list (database_id: #{database_id}, url_query: #{url_query})." )
                return [] unless json_data.key?( 'grant' )

                json_data['grant'].map { | grant | Types::Database::GrantUser.new( grant ) }
            end

            # Creates a new grant.
            #
            # @param [String] database_id   Database ID
            # @param [String] user_id       User ID
            #
            # @return [Nocoah::Types::Database::GrantUser]      When succeeded, created database grant.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-create-grant.html
            def create_db_grant( database_id, user_id: )
                json_data = api_post(
                    "/databases/#{database_id}/grant",
                    body: {
                        user_id: user_id
                    },
                    error_message: "Failed to create grant (database_id: #{database_id}, user_id: #{user_id})." 
                )
                return nil unless json_data.key?( 'grant' )

                Types::Database::GrantUser.new( json_data['grant'] )
            end

            # Deletes the grant.
            #
            # @param [String] database_id   Database ID
            # @param [String] user_id       User ID
            #
            # @return [String]              When succeeded, user ID of deleted grant.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-create-grant.html
            def delete_db_grant( database_id, user_id: )
                api_delete(
                    "/databases/#{database_id}/grant/#{user_id}",
                    error_message: "Failed to delete grant (database_id: #{database_id}, user_id: #{user_id})." 
                ) do | res |
                    user_id
                end
            end

            # Gets a database backup list.
            #
            # @option           [String]    database_id     Database ID
            # @param            [Hash]      url_query       URL query
            # @option url_query [Integer]   :offset         Offset
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Database::SortKeyBackup}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Database::Backup>]      When succeeded, database backup list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-list-database-backup.html
            def get_db_backup_list( database_id, **url_query )
                uri = URI.parse( "/databases/#{database_id}/backup" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get database backup list (database_id: #{database_id}, url_query: #{url_query})." )
                return [] unless json_data.key?( 'backup' )

                json_data['backup'].map { | backup | Types::Database::Backup.new( backup ) }
            end

            # Restores the database.
            #
            # @param [String] database_id   Database ID
            # @param [String] backup_id     Backup ID
            #
            # @return [String]              When succeeded, restored database ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-restore-database-backup.html
            def restore_database( database_id, backup_id: )
                api_post( 
                    "/databases/#{database_id}/action",
                    body: {
                        restore: {
                            backup_id: backup_id
                        }
                    },
                    error_message: "Failed to get restore database (database_id: #{database_id}, backup_id: #{backup_id})."
                ) do | res |
                    database_id
                end
            end

            # Gets a database user list.
            #
            # @param            [Hash]      url_query       URL query
            # @option url_query [String]    :service_id     Filter by service ID      
            # @option url_query [Integer]   :offset         (0) Offset
            # @option url_query [Integer]   :limit          (1000) Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Database::SortKeyUser}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Database::UserItem>]        When succeeded, database user list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_db_user_item
            # @see https://www.conoha.jp/docs/paas-database-list-database-account.html
            def get_db_user_list( **url_query )
                uri = URI.parse( "/users" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get database user list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'users' )

                json_data['users'].map { | user | Types::Database::UserItem.new( user ) }
            end

            # Gets a database user item.
            #
            # @param [String] user_id       User ID
            #
            # @return [Nocoah::Types::Database::UserItem]       When succeeded, database user item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_db_user_list
            # @see https://www.conoha.jp/docs/paas-database-get-database-account.html
            def get_db_user_item( user_id )
                json_data = api_get( "/users/#{user_id}", error_message: "Failed to get database user item (database_id: #{user_id})." )
                return nil unless json_data.key?( 'user' )

                Types::Database::UserItem.new( json_data['user'] )
            end

            # Creates a new database user.
            #
            # @param          [String]      service_id          Service ID
            # @param          [String]      user_name           User name
            # @param          [Hash]        options             Options
            # @option options [String]      :password           Password
            # @option options [String]      :hostname           Hostname that allow connection
            # @option options [String]      :memo               ("") Memo
            #
            # @return [Nocoah::Types::Database::UserItem]       When succeeded, created database user item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @example
            #   create_db_user(
            #       "9d6441f6-c5a0-4dcf-a1a9-1a4d724e51fd",
            #       user_name: "dbuser001",
            #       password: "wa6g76w08#",
            #       hostname: "cl1.example.com",
            #       memo: "memo"
            #   )
            #
            # @see https://www.conoha.jp/docs/paas-database-create-database-account.html
            def create_db_user( service_id, user_name:, **options )
                json_data = api_post(
                    "/users",
                    body: {
                        service_id: service_id,
                        user_name: user_name
                    }.merge( options ),
                    error_message: "Failed to create database user (service_id: #{service_id}, user_name: #{user_name}, options: #{options})." 
                )
                return nil unless json_data.key?( 'user' )

                Types::Database::UserItem.new( json_data['user'] )
            end

            # Updates the database user.
            #
            # @param          [String]      user_id         User ID
            # @param          [Hash]        options         Options
            # @option options [String]      :password       Password
            # @option options [String]      :memo           Memo
            #
            # @return [Nocoah::Types::Database::UserItem]       When succeeded, updated database user item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-update-database.html
            def update_db_user( user_id, **options )
                json_data = api_put(
                    "/users/#{user_id}",
                    body: options,
                    error_message: "Failed to update database user (user_id: #{user_id}, options: #{options})." 
                )
                return nil unless json_data.key?( 'user' )

                Types::Database::UserItem.new( json_data['user'] )
            end

            # Deletes the database user.
            #
            # @param          [String]      user_id         User ID
            #
            # @return [String]              When succeeded, deleted database user ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-database-delete-database-account.html
            def delete_database( user_id )
                api_delete( 
                    "/users/#{user_id}",
                    error_message: "Failed to delete database user (user_id: #{user_id}."
                ) do | res |
                    user_id
                end
            end

        end

    end


end