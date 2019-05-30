require 'date'
require_relative './image-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Image item detail
            class ImageItemDetail < ImageItem

                # @return [String] Image status
                # @see Nocoah::Types::Compute::ImageStatus
                attr_reader :status
                # @return [DateTime] Image created time
                attr_reader :created
                # @return [DateTime] Image updated time
                attr_reader :updated
                # @return [Integer] Image size (byte)
                attr_reader :image_size
                # @return [Integer] The minimum amount of RAM an image requires to boot (MiB)
                attr_reader :min_ram
                # @return [Integer] The minimum amount of disk space an image requires to boot (GiB)
                attr_reader :min_disk
                # @return [Integer] A percentage value of the image save progress
                attr_reader :progress
                # @return [Hash] Image metadata
                attr_reader :metadata
                
                # Creates a new {ImageItemDetail} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    super( data )

                    @status = data['status']
                    @created = DateTime.parse( data['created'] ) rescue nil
                    @updated = DateTime.parse( data['updated'] ) rescue nil
                    @image_size = data['OS-EXT-IMG-SIZE:size']
                    @min_ram = data['minRam']
                    @min_disk = data['minDisk']
                    @progress = data['progress']
                    @metadata = data['metadata']
                end

            end

            # Image status
            module ImageStatus
                # Active
                ACTIVE = "ACTIVE"
                # Saving
                SAVING = "SAVING"
                # Deleted
                DELETED = "DELETED"
                # In error
                ERROR = "ERROR"
                # Unknown status
                UNKNOWN = "UNKNOWN"
            end

        end

    end

end