require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Object Storage
        module ObjectStorage

            # Object item
            class ObjectItem < Base

                # @return [String] Object name
                attr_reader :object_name
                # @return [String] Content type
                attr_reader :content_type
                # @return [Integer] Object size (bytes)
                attr_reader :size
                # @return [String] Hash
                attr_reader :hash
                # @return [DateTime] Last modified
                attr_reader :last_modified

                # Creates a new {ObjectItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @object_name = data['name']
                    @content_type = data['content_type']
                    @size = data['bytes']
                    @hash = data['hash']
                    @last_modified = DateTime.parse( data['last_modified'] ) rescue nil
                end

            end

        end

    end

end