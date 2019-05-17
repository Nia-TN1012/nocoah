require_relative '../base'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Image item
            class ImageItem < Base

                # @return [String] Image ID
                attr_reader :image_id
                # @return [String] Image name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                # Creates a new {ImageItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @image_id = data['id']
                    @name = data['name']
                    @links = data['links'].map { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end

            end

        end

    end

end