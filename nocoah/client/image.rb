require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/image'

# Nocoah
module Nocoah

    # Client
    module Client

        # Image API
        class Image < Base

            # Image API Endpoint ( '%s' contains a string representing the region. )
            ENDPOINT_BASE = "https://image-service.%s.conoha.io/v2"

            # Gets an image list.
            #
            # @param            [Hash]      url_query       Options
            # @option url_query [Integer]   limit           (nil) The number of item
            # @option url_query [String]    marker          (nil) Last-seen image ID
            # @option url_query [String]    name            (nil) Filters by image name
            # @option url_query [String]    visibility      (nil) Filters by image visibility ( 'public', 'private', 'community' or 'shared' )
            # @option url_query [String]    member_status   ("accepted") Filters by image member status ( 'accepted', 'pending', 'rejected', or 'all' )
            # @option url_query [String]    owner           (nil) Filters by image owner ( tenant ID )
            # @option url_query [String]    status          (nil) Filters by image status
            # @option url_query [Integer]   size_min        Filter by minimum image size (byte)
            # @option url_query [Integer]   size_max        Filter by maximum image size (byte)
            # @option url_query [String]    sort_key        ("created_at") Sorts by attribute
            # @option url_query [String]    sort_dir        ("desc") Sort direction ( 'asc' or 'desc' )
            # @option url_query [String]    tag             (nil) Filters by image tag
            #
            # @return [Array<Nocoah::Types::Image::ImageItem>]      When succeeded, image list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_image_item
            # @see https://www.conoha.jp/docs/image-get_images_list.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=list-images-detail#list-images
            def get_image_list( **url_query )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                uri = URI.parse( "#{@endpoint}/images" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                http_client = HTTPClient.new;
                res = http_client.get( uri.to_s, header: headers )
                raise APIError, message: "Failed to get image list (url_query: #{url_query}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'images' )

                json_data['images'].map do | image |
                    Types::Image::ImageItem.new( image )
                end
            end

            # Gets an image item.
            #
            # @param [String]   image_id        Image ID
            #
            # @return [Nocoah::Types::Image::ImageItem]     When succeeded, image item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see get_image_list
            # @see https://www.conoha.jp/docs/image-get_images_detail_specified.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-image-detail#show-image
            def get_image_item( image_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/images/#{image_id}", header: headers )
                raise APIError, message: "Failed to get image item (image_id: #{image_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                Types::Image::ImageItem.new( json_data )
            end

            # Gets an image container schema.
            #
            # @return [Hash]                When succeeded, image container schema.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see get_image_schema
            # @see get_image_member_container_schema
            # @see get_image_member_schema
            # @see https://www.conoha.jp/docs/image-get_schemas_images_list.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-images-schema-detail#show-images-schema
            def get_image_container_schema
                json_data = get_image_schema_core( "image container" )
            end

            # Gets an image schema.
            #
            # @return [Hash]                When succeeded, image schema.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see get_image_container_schema
            # @see get_image_member_container_schema
            # @see get_image_member_schema
            # @see https://www.conoha.jp/docs/image-get_schemas_image_list.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-image-schema-detail#show-image-schema
            def get_image_schema
                json_data = get_image_schema_core( "image" )
            end

            # Gets an image member container schema.
            #
            # @return [Hash]                When succeeded, image member container schema.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see get_image_container_schema
            # @see get_image_schema
            # @see get_image_member_schema
            # @see https://www.conoha.jp/docs/image-get_schemas_members_list.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-image-members-schema-detail#show-image-members-schema
            def get_image_member_container_schema
                json_data = get_image_schema_core( "member container" )
            end

            # Gets an image member schema.
            #
            # @return [Hash]                When succeeded, image member schema.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see get_image_container_schema
            # @see get_image_schema
            # @see get_image_member_container_schema
            # @see https://www.conoha.jp/docs/image-get_schemas_member_list.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-image-member-schema-detail#show-image-member-schema
            def get_image_member_schema
                json_data = get_image_schema_core( "member" )
            end

            # Gets an image member list.
            #
            # @param [String]   image_id        Image ID
            #
            # @return [Array<Nocoah::Types::Image::MemberItem>]     When succeeded, image member list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/image-get_members_list.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-image-detail#show-image
            def get_image_member_list( image_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/images/#{image_id}/members", header: headers )
                raise APIError, message: "Failed to get image member list (image_id: #{image_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'members' )

                json_data['members'].map do | member |
                    Types::Image::MemberItem.new( member )
                end
            end

            # Deletes the image.
            #
            # @param [String]   image_id        Image ID to delete
            #
            # @return [String]              When succeeded, deleted image ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/image-remove_image.html
            # @see https://developer.openstack.org/api-ref/image/v2/index.html?expanded=delete-image-detail#delete-image
            def delete_image( image_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/images/#{image_id}", header: headers )
                raise APIError, message: "Failed to delete image (image_id: #{image_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                image_id
            end

            # Sets the image storage quota of the region set in {Nocoah::Config}.
            #
            # @param [String]   image_quota     Image quota ( e.g. "550GB" )
            #
            # @note ConoHa: You can specify a total of 50GB plus additional (500GB units).
            #
            # @return [String]              When succeeded, image quota.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/image-set_quota.html
            def set_image_quota( image_quota )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    quota: {
                        "#{@identity.config.region}_image_size": image_quota
                    }
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/quota", header: headers, body: body.to_json )
                raise APIError, message: "Failed to set image quota (image_quota: #{image_quota}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST

                json_data = JSON.parse( res.body )
                return json_data['quota']["#{@identity.config.region}_image_size"]
            end

            # Gets the image storage quota of the region set in {Nocoah::Config}.
            #
            # @return [String]              When succeeded, image quota.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/image-set_quota.html
            def get_image_quota
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/quota", header: headers )
                raise APIError, message: "Failed to get image quota info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST

                json_data = JSON.parse( res.body )
                return json_data['quota']["#{@identity.config.region}_image_size"]
            end

            private

            # Gets an image schema.
            #
            # @param [String] target_schema     Target schema
            #
            # @return [Hash]                When succeeded, image schema.
            # @raise [ArgumentError]        When target_schema is invalid value.
            # @raise [Nocoah::APIError]     When failed.
            def get_image_schema_core( target_schema )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                case target_schema
                when "image"
                    path = "image"
                    name = "image"
                when "image container"
                    path = "images"
                    name = "image container"
                when "member"
                    path = "member"
                    name = "image member"
                when "member container"
                    path = "members"
                    name = "image member container"
                else
                    raise ArgumentError, "Invalid target schema: #{target_schema}"
                end

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/schemas/#{path}", header: headers )
                raise APIError, message: "Failed to get #{name} schema.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                JSON.parse( res.body )
            end

        end

    end

end