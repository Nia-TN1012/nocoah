require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Object Storage
        module ObjectStorage

            # Object info
            class ObjectInfo < Base

                # @return [String] Etag
                attr_reader :etag
                # @return [String] Policy name
                attr_reader :content_type
                # @return [Integer] Object size (bytes)
                attr_reader :size
                # @return [DateTime] Last modified
                attr_reader :last_modified

                # Creates a new {ObjectInfo} class instance.
                #
                # @param [Hash] data        Data
                def initialize( data )
                    @etag = data['Etag']
                    @content_type = data['Content-Type']
                    @size = data['Content-Length']
                    @last_modified = DateTime.parse( data['Last-Modified'] ) rescue nil
                end

            end

        end

    end

end