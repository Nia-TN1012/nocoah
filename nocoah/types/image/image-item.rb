require 'date'
require_relative '../base'
require_relative '../../utility'

# Nocoah
module Nocoah

    # Types
    module Types

        # Image
        module Image

            # Image item
            class ImageItem < Base

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

                # Creates a new {ImageItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @image_id = data['id']
                    @name = data['name']
                    @status = data['status']
                    @tags = data['tags']
                    @container_format = data['container_format']
                    @created_at = DateTime.parse( data['created_at'] )
                    @size = data['size']
                    @disk_format = data['disk_format']
                    @visibility = data['visibility']
                    @protected = Utility.to_b( data['protected'] )
                    @min_ram = data['min_ram']
                    @min_disk = data['min_disk']
                    @self = data['self']
                    @file = data['file']
                    @direct_url = data['direct_url']
                    @checksum = data['checksum']
                    @owner = data['owner']
                    @hw_qemu_guest_agent = data['hw_qemu_guest_agent']
                    @schema = data['schema']
                end

            end

        end

    end

end