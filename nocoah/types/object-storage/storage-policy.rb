require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Object Storage
        module ObjectStorage

            # Storage policy
            class StoragePolicy < Base

                # @return [String] Policy name
                attr_reader :policy_name
                # @return [Integer] Container count
                attr_reader :container_count
                # @return [Integer] Object count
                attr_reader :object_count
                # @return [Integer] Object Storage used size (bytes)
                attr_reader :used_size

                # Creates a new {StoragePolicy} class instance.
                #
                # @param [String]   name        Policy name
                # @param [Hash]     data        Data
                def initialize( name, data )
                    @policy_name = name
                    @container_count = data["X-Account-Storage-Policy-#{name}-Container-Count"]
                    @object_count = data["X-Account-Storage-Policy-#{name}-Object-Count"]
                    @used_size = data["X-Account-Storage-Policy-#{name}-Bytes-Used"]
                end

            end

        end

    end

end