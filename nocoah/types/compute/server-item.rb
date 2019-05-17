require_relative '../base'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Virtual machine item
            class ServerItem < Base

                # @return [String] Server ID
                attr_reader :server_id
                # @return [String] Server name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                # Creates a new {ServerItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @server_id = data['id']
                    @name = data['name']
                    @links = data['links'].map { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end
                
            end

        end

    end

end