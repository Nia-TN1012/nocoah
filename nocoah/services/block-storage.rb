require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/block-storage'

# Nocoah
module Nocoah

    # Services
    module Services

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
            end

        end

    end

end