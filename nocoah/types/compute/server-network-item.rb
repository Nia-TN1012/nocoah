require_relative './server-address-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Server network item
            class ServerNetworkItem

                # @return [String] Network label
                attr_reader :network_label
                # @return [Array<Nocoah::Types::Compute::ServerAddressItem>] IP addresses
                attr_reader :addresses

                # Creates a {ServerNetworkItem} instance.
                #
                # @param [String]       network_label       Network label
                # @param [Array<Hash>]  addresses           IP addresses
                def initialize( network_label, addresses )
                    @network_label = network_label
                    @addresses = addresses.map { | address | ServerAddressItem.new( address ) } rescue []
                end

                def to_s
                    {
                        'Network label' => @network_label,
                        'Addresses' => @addresses.map { | address | address.to_s },
                    }.to_s
                end

            end

        end

    end

end