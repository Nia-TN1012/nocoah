require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/object-storage'

# Nocoah
module Nocoah

    # Client
    module Client

        # Object Storage API
        class ObjectStorage < Base

            # Object Storage API Endpoint ( '%s' contains a string representing the region. )
            ENDPOINT_BASE = "https://object-storage.%s.conoha.io/v1"

            # There is no corresponding API for this method. Always returns nil.
            #
            # @return [nil] Always returns nil.
            def version
                nil
            end

            # Gets an account info.
            #
            # @return [Nocoah::Types::ObjectStorage::AccountInfo]       When succeeded, account info.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/swift-show_account_details_and_list_containers.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=show-account-details-and-list-containers-detail#show-account-details-and-list-containers
            def get_account_info
                json_data = api_get( "/nc_#{@identity.config.tenant_id}", error_message: "Failed to get account info." ) do | res |
                    res.header.all.to_h
                end
                return nil if json_data.empty?

                Types::ObjectStorage::AccountInfo.new( json_data )
            end

            # Gets a container list.
            #
            # @param            [Boolean]   newest          When true, Object Storage queries all replicas to return the most recent one.
            # @param            [Hash]      url_query       URL query         
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :marker         Filter only container names greater than marker name
            # @option url_query [String]    :end_marker     Filter only container names less than end_marker name
            # @option url_query [String]    :prefix         Filter only container names beginning with prefix.
            # @option url_query [String]    :delimiter      Used when traversing container names as in a pseudo-directory hierarchy.
            #
            # @return [Array<Nocoah::Types::ObjectStorage::ContainerItem>]      When succeeded, container list.
            # @return [Hash]                                                    When specified delimiter, pseudo sub-directory name (:subdir) and container list (:containers).
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see https://www.conoha.jp/docs/swift-show_account_details_and_list_containers.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=show-account-details-and-list-containers-detail#show-account-details-and-list-containers
            def get_conatiner_list( newest: false, **url_query )
                uri = URI.parse( "/nc_#{@identity.config.tenant_id}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                json_data = api_get(
                    uri.to_s,
                    opt_header: newest ? { 'X-Newest': true } : {},
                    error_message: "Failed to get container list. (url_query: #{url_query})"
                )
                return [] if json_data.empty?

                if url_query.key?( :delimiter )
                    subdir = json_data[0].key?( 'subdir' ) ? json_data.shift['subdir'] : nil
                    containers = json_data.map { | container | Types::ObjectStorage::ContainerItem.new( container ) } rescue []
                    {
                        subdir: subdir,
                        containers: containers
                    }
                else
                    json_data.map { | container | Types::ObjectStorage::ContainerItem.new( container ) } rescue []
                end
            end

            # Sets the account quota.
            #
            # @param [Integer] quota    Quota ( ConoHa: Multiple of 100 )
            #
            # @return [Integer]             When succeeded, set account quota.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/swift-set_account_quota.html
            # @see https://www.conoha.jp/vps/pricing/
            def set_quota( quota )
                api_post(
                    "/nc_#{@identity.config.tenant_id}",
                    opt_header: {
                        'X-Account-Meta-Quota-Giga-Bytes': quota
                    },
                    error_message: "Failed to set account quota. (quota: #{quota})"
                ) do | res |
                    quota
                end
            end

            # Gets a container info.
            #
            # @param [String] container_name    Container name
            #
            # @return [Nocoah::Types::ObjectStorage::ContainerInfo]     When succeeded, container info.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/swift-show_container_details_and_list_objects.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=show-container-details-and-list-objects-detail#show-container-details-and-list-objects
            def get_container_info( container_name )
                json_data = api_get(
                    "/nc_#{@identity.config.tenant_id}/#{container_name}",
                    error_message: "Failed to get container info (container_name: #{container_name})."
                ) do | res |
                    res.header.all.to_h
                end
                return nil if json_data.empty?

                Types::ObjectStorage::ContainerInfo.new( json_data )
            end

            # Gets an object list.
            #
            # @param            [String]    container_name      Container name
            # @param            [Boolean]   newest              When true, Object Storage queries all replicas to return the most recent one.
            # @param            [Hash]      url_query           URL query         
            # @option url_query [Integer]   :limit              Number of item
            # @option url_query [String]    :marker             Filter only object names greater than marker name
            # @option url_query [String]    :end_marker         Filter only object names less than end_marker name
            # @option url_query [String]    :prefix             Filter only object names beginning with prefix.
            # @option url_query [String]    :delimiter          Used when traversing object names as in a pseudo-directory hierarchy.
            #
            # @return [Array<Nocoah::Types::ObjectStorage::ObjectItem>]     When succeeded, object list.
            # @return [Hash]                                                When specified delimiter, pseudo sub-directory name (:subdir) and object list (:objects).
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see https://www.conoha.jp/docs/swift-show_container_details_and_list_objects.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=show-container-details-and-list-objects-detail#show-container-details-and-list-objects
            def get_object_list( container_name, newest: false, **url_query )
                uri = URI.parse( "/nc_#{@identity.config.tenant_id}/#{container_name}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                json_data = api_get(
                    uri.to_s,
                    opt_header: newest ? { 'X-Newest': true } : {},
                    error_message: "Failed to get object list (container_name: #{container_name})."
                )
                return [] if json_data.empty?

                if url_query.key?( :delimiter )
                    subdir = json_data[0].key?( 'subdir' ) ? json_data.shift['subdir'] : nil
                    objects = json_data.map { | object | Types::ObjectStorage::ObjectItem.new( object ) } rescue []
                    {
                        subdir: subdir,
                        objects: objects
                    }
                else
                    json_data.map { | object | Types::ObjectStorage::ObjectItem.new( object ) } rescue []
                end
            end

            # Creates a new container.
            #
            # @param [String]  container_name              Container name        
            #
            # @see https://www.conoha.jp/docs/swift-create_container.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=create-container-detail#create-container
            def create_container( container_name )
                api_put(
                    "/nc_#{@identity.config.tenant_id}/#{container_name}",
                    error_message: "Failed to create container. (container_name: #{container_name})"
                ) do | res |
                    container_name
                end
            end

            # Deletes the container.
            #
            # @param [String]  container_name              Container name        
            #
            # @see https://www.conoha.jp/docs/swift-delete_container.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=delete-container-detail#delete-container
            def delete_container( container_name )
                api_delete(
                    "/nc_#{@identity.config.tenant_id}/#{container_name}",
                    error_message: "Failed to delete container. (container_name: #{container_name})"
                ) do | res |
                    container_name
                end
            end

            # Gets an object info.
            #
            # @param [String]    container_name          Container name
            # @param [String]    object_name             Object name
            #
            # @return [Nocoah::Types::ObjectStorage::ObjectInfo]    When succeeded, object info.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/swift-get_object_content_and_metadata.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=show-object-metadata-detail#show-object-metadata
            def get_object_info( container_name, object_name )
                json_data = api_get(
                    "/nc_#{@identity.config.tenant_id}/#{container_name}/#{object_name}",
                    error_message: "Failed to get object info (container_name: #{container_name}, object_name: #{object_name})."
                ) do | res |
                    res.header.all.to_h
                end
                return nil if json_data.empty?

                Types::ObjectStorage::ObjectInfo.new( json_data )
            end

            # Uploads a object file.
            #
            # @param [String] object_file_path      Upload file path
            # @param [String] content_type          Content type
            # @param [String] container_name        Container name
            # @param [String] object_name           Object name ( When nil, will be file name of object_file_path )
            #
            # @return [String]              When succeeded, object etag.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/swift-object_upload.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=create-or-replace-object-detail#create-or-replace-object
            def upload_object( object_file_path, content_type: nil, container_name:, object_name: nil )
                object_name ||= File.basename( object_file_path )
                api_put(
                    "/nc_#{@identity.config.tenant_id}/#{container_name}/#{object_name}",
                    opt_header: content_type.nil? ? {} : { 'Content-Type': content_type },
                    body: File.open( object_file_path ),
                    error_message: "Failed to upload object (object_file_path: #{object_file_path}, content_type: #{content_type}, container_name: #{container_name}, object_name: #{object_name})."
                ) do | res |
                    res.header.get( 'Etag' )
                end
            end

            # Downloads the object file.
            #
            # @param [String]    container_name          Container name
            # @param [String]    object_name             Object name
            # @param [String]    dest_file_path          Output file path
            #
            # @return [Nocoah::Types::ObjectStorage::ObjectInfo]    When succeeded, object info.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/swift-object_download.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=get-object-content-and-metadata-detail#get-object-content-and-metadata
            def download_object( container_name, object_name, dest_file_path: )
                File.open( dest_file_path, "wb" ) do | file |
                    api_get_content(
                        "/nc_#{@identity.config.tenant_id}/#{container_name}/#{object_name}",
                        error_message: "Failed to download object (container_name: #{container_name}, object_name: #{object_name}, dest_file_path: #{dest_file_path})."
                    ) do | chunk |
                        file.write( chunk )
                    end
                end

                object_name
            end

            # Deletes the object.
            #
            # @param [String]    container_name          Container name
            # @param [String]    object_name             Object name
            #
            # @return [String]              When succeeded, deleted object name.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/swift-delete_object.html
            # @see https://developer.openstack.org/api-ref/object-store/?expanded=get-object-content-and-metadata-detail,delete-object-detail#delete-object
            def copy_object( container_name, object_name )
                api_delete(
                    "/nc_#{@identity.config.tenant_id}/#{container_name}/#{object_name}",
                    opt_header: {
                        Destination: dest_object_path
                    },
                    error_message: "Failed to delete object (container_name: #{container_name}, object_name: #{object_name})."
                ) do | res |
                    object_name
                end
            end

        end

    end

end