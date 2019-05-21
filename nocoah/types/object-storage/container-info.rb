require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Object Storage
        module ObjectStorage

            # Container info
            class ContainerInfo < Base

                # @return [String] Policy name
                attr_reader :policy_name
                # @return [Integer] Object count in the container
                attr_reader :object_count
                # @return [Integer] Container size (bytes)
                attr_reader :size

                # Creates a new {ContainerInfo} class instance.
                #
                # @param [Hash] data        Data
                def initialize( data )
                    @policy_name = data['X-Storage-Policy']
                    @object_count = data['X-Container-Object-Count']
                    @used_size = data['X-Container-Bytes-Used']
                end

            end

        end

    end

end