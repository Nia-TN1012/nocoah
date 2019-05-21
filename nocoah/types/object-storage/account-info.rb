require_relative '../base'
require_relative './storage-policy'

# Nocoah
module Nocoah

    # Types
    module Types

        # Object Storage
        module ObjectStorage

            # Account info
            class AccountInfo < Base

                # @return [Integer] Container count
                attr_reader :container_count
                # @return [Integer] Object count
                attr_reader :object_count
                # @return [Integer] Object Storage used size (bytes)
                attr_reader :used_size
                # @return [Integer] Object Storage quota (bytes)
                attr_reader :quota
                # @return [Array<Nocoah::Types::ObjectStorage::StoragePolicy>] Storage policy
                attr_reader :storage_policy

                # Creates a new {AccountInfo} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @container_count = data['X-Account-Container-Count']
                    @object_count = data['X-Account-Object-Count']
                    @used_size = data['X-Account-Bytes-Used']
                    @quota = data['X-Account-Meta-Quota-Bytes']
                    @storage_policy = data.select { | k, v | 
                        k.match( /^X-Account-Storage-Policy-(.*?)-(Bytes-Used|Container-Count|Object-Count)$/ )
                    }.group_by { | k, v |
                        k.match( /^X-Account-Storage-Policy-(.*?)-(Bytes-Used|Container-Count|Object-Count)$/ )[1]
                    }.map { | k, v |
                        StoragePolicy.new( k, v.to_h )
                    } rescue []
                end

            end

        end

    end

end