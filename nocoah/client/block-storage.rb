require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/block-storage'

# Nocoah
module Nocoah

    # Client
    module Client

        # Block Storage API
        class BlockStorage < Base

            # Block Storage API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            ENDPOINT_BASE = "https://block-storage.%s.conoha.io/v2"

            # Gets volume type list.
            #
            # @return [Array<Nocoah::Types::BlockStorage::VolumeTypeItem>]      When succeeded, volume type list.
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see get_volume_type_item
            # @see https://www.conoha.jp/docs/cinder-get_volume_types_list.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=list-all-volume-types-for-v2-detail#list-all-volume-types-for-v2
            def get_volume_type_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/types", header: headers )
                raise APIError, message: "Failed to get volume type list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'volume_types' )

                json_data['volume_types'].map do | volume_type |
                    Types::BlockStorage::VolumeTypeItem.new( volume_type )
                end
            end

            # Gets volume type item.
            #
            # @param [String]   volume_type_id      Volume type ID
            #
            # @return [Nocoah::Types::BlockStorage::VolumeTypeItem]     When succeeded, volume type item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_volume_type_list
            # @see https://www.conoha.jp/docs/cinder-get_volume_type_specified.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=show-volume-type-details-for-v2-detail#show-volume-type-details-for-v2
            def get_volume_type_item( volume_type_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/types/#{volume_type_id}", header: headers )
                raise APIError, message: "Failed to get volume type item (volume_type_id: #{volume_type_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'volume_type' )

                Types::BlockStorage::VolumeTypeItem.new( json_data['volume_type'] )
            end

            # Gets volume list.
            #
            # @return [Array<Nocoah::Types::BlockStorage::VolumeItem>]      When succeeded, volume list.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_volume_detail_list
            # @see get_volume_detail
            # @see https://www.conoha.jp/docs/cinder-get_volumes_list.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=list-volumes-detail#list-volumes
            def get_volume_list
                json_data = get_volume_list_core( false )
                return [] unless json_data.key?( 'volumes' )

                json_data['volumes'].map do | volume |
                    Types::BlockStorage::VolumeItem.new( volume )
                end
            end

            # Gets volume detail list.
            #
            # @return [Array<Nocoah::Types::BlockStorage::VolumeItemDetail>]    When succeeded, volume detail list.
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see get_volume_list
            # @see get_volume_detail
            # @see https://www.conoha.jp/docs/cinder-get_volumes_detail.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=list-volumes-with-details-detail#list-volumes-with-details
            def get_volume_detail_list
                json_data = get_volume_list_core( true )
                return [] unless json_data.key?( 'volumes' )

                json_data['volumes'].map do | volume |
                    Types::BlockStorage::VolumeItemDetail.new( volume )
                end
            end

            # Gets volume detail item.
            #
            # @return [Nocoah::Types::BlockStorage::VolumeItemDetail]       When succeeded, volume detail item.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_volume_list
            # @see get_volume_detail_list
            # @see https://www.conoha.jp/docs/cinder-get_volume_detail_specified.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=show-volume-details-detail#show-volume-details
            def get_volume_detail( volume_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/volumes/#{volume_id}", header: headers )
                raise APIError, message: "Failed to get volume item (volume_id: #{volume_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'volume' )

                Types::BlockStorage::VolumeItemDetail.new( json_data['volume'] )
            end

            # Creates a new volume.
            #
            # @param            [String]            volume_id           Volume ID ( When nil, creates a new volume, and when specified a volume ID, creates a duplicate of that volume. )
            # @param            [String]            name                Volume name ( Required when creating a new volume. )
            # @param            [Integer]           size                Volume size (GiB)
            # @param            [Hash]              options             Optional settings
            # @option options   [String]            description         (nil) Description
            # @option options   [String]            imageRef            (nil) Image ID
            # @option options   [Boolean]           bootable            (false) When true, creates a bootable volume
            # @option options   [Hash]              metadata            ({}) Volume metadata
            #
            # @return [Nocoah::Types::BlockStorage::VolumeItemDetail]       When succeeded, created volume detail item.
            # @raise [Nocoah::APIError]                                     When failed.
            # @raise [ArgmentError]                                         When volume_id and name are nil.
            #
            # @note ConoHa: You can create only 200 GiB or 500 GiB volumes.
            #
            # @see https://www.conoha.jp/docs/cinder-create_volume.html
            # @see https://www.conoha.jp/docs/cinder-create_volume_specified.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=create-volume-detail#show-volume-details
            def create_volume( volume_id: nil, name: nil, size:, **options )
                raise ArgumentError, "You must specify a valid value for volume_id or name." if volume_id.nil? && name.nil?

                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                options[:source_volid] = volume_id unless volume_id.nil?
                options[:name] = name unless name.nil?
                body = {
                    volume: options
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/#{@identity.config.tenant_id}/volumes", header: headers, body: body.to_json )
                raise APIError, message: "Failed to create volume (volume_id: #{volume_id}, name: #{name}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'volume' )

                Types::BlockStorage::VolumeItemDetail.new( json_data['volume'] )
            end

            # Delete a volume.
            #
            # @param [String]   volume_id           Volume ID to delete
            #
            # @return [String]              When succeeded, deleted volume ID.
            # @raise [Nocoah::APIError]     hen failed.
            #
            # @note Cannot delete attached volumes.
            #
            # @see https://www.conoha.jp/docs/cinder-delete_volume.html
            # @see https://developer.openstack.org/api-ref/block-storage/v2/?expanded=delete-volume-detail#delete-volume
            def delete_volume( volume_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/#{@identity.config.tenant_id}/volumes/#{volume_id}", header: headers )
                raise APIError, message: "Failed to delete volume (volume_id: #{volume_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                volume_id
            end

            # Saves the volume as an image.
            #
            # @param            [String]            volume_id           Volume ID
            # @param            [String]            image_name          Image name
            # @param            [Hash]              options             Optional settings
            # @option options   [String]            disk_format         ("ovf") Disk format
            # @option options   [String]            container_format    ("qcow2") Container format
            #
            # @return [Nocoah::Types::BlockStorage::VolumeImageItem]        When succeeded, saved image item.
            # @raise [Nocoah::APIError]                                     When failed.
            # @raise [ArgmentError]                                         When volume_id and name are nil.
            #
            # @see https://www.conoha.jp/docs/cinder-save_volume.html
            def save_volume_to_image( volume_id, image_name:, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                options[:name] = image_name
                body = {
                    'os-volume_upload_image': options
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/#{@identity.config.tenant_id}/volumes/#{volume_id}", header: headers )
                raise APIError, message: "Failed to save volume (volume_id: #{volume_id}, image_name: #{image_name}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
            end

            private

            # Gets volume list.
            #
            # @param [Boolean]   is_detail      When true, gets detail list
            #
            # @return [Hash]                When succeeded, volume list.
            # @raise [Nocoah::APIError]     When failed.
            def get_volume_list_core( is_detail = false )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/volumes#{is_detail ? "/detail" : ""}", header: headers )
                raise APIError, message: "Failed to get volume #{is_detail ? "detail list" : "list"}.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
            end

        end

    end

end