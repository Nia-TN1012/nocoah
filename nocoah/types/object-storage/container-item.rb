require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Object Storage
        module ObjectStorage

            # Container item
            class ContainerItem < Base

                # @return [String] Container name
                attr_reader :container_name
                # @return [Integer] Object count in the container
                attr_reader :object_count
                # @return [Integer] Container size (bytes)
                attr_reader :size

                # Creates a new {ContainerItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @container_name = data['name']
                    @object_count = data['count']
                    @size = data['bytes']
                end

            end

        end

    end

end