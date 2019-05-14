require 'date'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Virtual machine template (Flavor)
            class FlavorItem

                # @return [String] Flavor ID
                attr_reader :flavor_id
                # @return [String] Flavor name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                def initialize( data )
                    @flavor_id = data['id']
                    @name = data['name']
                    if data.key?( 'links' )
                        @links = data['links'].map() do | link |
                            Common::Link.new( link['href'], link['rel'] )
                        end
                    else
                        @links = []
                    end

                end

                def to_s
                    {
                        'Flavor ID' => @flavor_id,
                        'Flavor name' => @name,
                        'Links' => @links.map { | link | link.to_s }
                    }.to_s
                end

            end

        end

    end

end