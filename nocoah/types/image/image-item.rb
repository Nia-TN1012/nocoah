# Nocoah
module Nocoah

    # Types
    module Types

        # Image
        module Image

            # Image item
            class ImageItem

                # @return [String] Image ID
                attr_reader :image_id
                # @return [String] Image name
                attr_reader :name
                # @return [String] Status
                attr_reader :status
                # @return [Array] Tags
                attr_reader :tags
                # @return [String] Container format
                attr_reader :container_format
                # @return [Datetime] Created time
                attr_reader :created_at
                # @return [Integer] Image size (byte)
                attr_reader :size
                # @return [String] Disk format
                attr_reader :disk_format
                # @return [String] Visibility
                attr_reader :visibility
                # @return [Boolean] Protected
                attr_reader :protected
                # @return [Integer] Amount of RAM in MB that is required to boot the image
                attr_reader :min_ram
                # @return [Integer] Amount of disk space in GB that is required to boot the image
                attr_reader :min_disk
                # @return [String] Image url
                attr_reader :self
                # @return [String] Image file url
                attr_reader :file
                # @return [String] Image file direc url
                attr_reader :direct_url
                # @return [String] Image hash
                attr_reader :checksum
                # @return [String] Image owner
                attr_reader :owner
                # @return [String] Guest agent support
                attr_reader :hw_qemu_guest_agent
                # @return [String] Image schema url
                attr_reader :schema

            end

        end

    end

end