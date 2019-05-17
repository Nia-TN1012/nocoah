require_relative '../base'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Virtual machine template (Flavor)
            class FlavorItem < Base

                # @return [String] Flavor ID
                attr_reader :flavor_id
                # @return [String] Flavor name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                # Creates a new {FlavorItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @flavor_id = data['id']
                    @name = data['name']
                    @links = data['links'].map { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end

            end

        end

    end

end