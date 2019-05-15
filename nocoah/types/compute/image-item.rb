require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Image item
            class ImageItem

                # @return [String] Image ID
                attr_reader :image_id
                # @return [String] Image name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                def initialize( data )
                    @image_id = data['id']
                    @name = data['name']
                    @links = data['links'].map { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end

                def to_s
                    {
                        'Image ID' => @image_id,
                        'Image name' => @name,
                        'Links' => @links.map { | link | link.to_s }
                    }.to_s
                end

            end

        end

    end

end