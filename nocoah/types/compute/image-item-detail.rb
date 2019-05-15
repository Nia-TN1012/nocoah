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
                attr_reader :status
                # @return [DateTime] Image created time
                attr_reader :created
                # @return [DateTime] Image updated time
                attr_reader :updated
                # @return [Integer] Image size (byte)
                attr_reader :image_size
                # @return [Integer] The minimum amount of RAM an image requires to boot (MiB)
                attr_reader :minRam
                # @return [Integer] The minimum amount of disk space an image requires to boot (GiB)
                attr_reader :minDisk
                # @return [Integer] A percentage value of the image save progress
                attr_reader :progress
                # @return [Hash] Image metadata
                attr_reader :metadata
                
                def initialize( data )
                    super( data )

                    @status = data['status']
                    @created = DateTime.parse( data['created'] ) rescue nil
                    @updated = DateTime.parse( data['updated'] ) rescue nil
                    @image_size = data['OS-EXT-IMG-SIZE:size']
                    @minRam = data['minRam']
                    @minDisk = data['minDisk']
                    @progress = data['progress']
                    @metadata = data['metadata']
                end

                def to_s
                    {
                        'Image ID' => @image_id,
                        'Image name' => @name,
                        'Links' => @links.map { | link | link.to_s },
                        'Status' => @status,
                        'Created' => @created,
                        'Updated' => @updated,
                        'Image size' => @image_size,
                        'Min RAM' => "#{@minRam} MiB",
                        'Min disk space' => "#{minDisk} GiB",
                        'Save progress' => @progress,
                        'Metadata' => @metadata,
                    }.to_s
                end

            end

        end

    end

end