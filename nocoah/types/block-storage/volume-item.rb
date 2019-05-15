require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Block Storage
        module BlockStorage

            # Volume item
            class VolumeItem

                # @return [String] Volume ID
                attr_reader :volume_id
                # @return [String] Volume name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                def initialize( data )
                    @volume_id = data['id']
                    @name = data['name']
                    @links = data['links'].map() { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end

                def to_s
                    {
                        'Volume ID' => @volume_id,
                        'Volume name' => @name,
                        'Links' => @links.map { | link | link.to_s },
                    }.to_s
                end

            end

        end

    end

end