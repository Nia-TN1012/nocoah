require_relative '../base'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Block Storage
        module BlockStorage

            # Volume item
            class VolumeItem < Base

                # @return [String] Volume ID
                attr_reader :volume_id
                # @return [String] Volume name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                # Creates a new {VolumeItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @volume_id = data['id']
                    @name = data['name']
                    @links = data['links'].map() { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end

            end

        end

    end

end