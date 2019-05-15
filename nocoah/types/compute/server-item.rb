require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Virtual machine item
            class ServerItem

                # @return [String] Server ID
                attr_reader :server_id
                # @return [String] Server name
                attr_reader :name
                # @return [Array<Nocoah::Types::Common::Link>] Links
                attr_reader :links

                def initialize( data )
                    @server_id = data['id']
                    @name = data['name']
                    @links = data['links'].map { | link | Common::Link.new( link['href'], link['rel'] ) } rescue []
                end

                def to_s
                    {
                        'Server ID' => @server_id,
                        'Server name' => @name,
                        'Links' => @links.map { | link | link.to_s }
                    }.to_s
                end
                
            end

        end

    end

end