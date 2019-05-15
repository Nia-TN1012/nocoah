require 'httpclient'
require 'json'
require 'uri'
require 'base64'
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
            end

        end

    end

end