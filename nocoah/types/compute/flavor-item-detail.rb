require_relative '../../utility'
require_relative './flavor-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Virtual machine template (Flavor) detail
            class FlavorItemDetail < FlavorItem

                # @return [Integer] Number of Virtual CPU
                attr_reader :vcpus
                # @return [Integer] RAM size (MiB)
                attr_reader :ram
                # @return [Integer] Swap size (MiB)
                attr_reader :swap
                # @return [Integer] RXTX Factor
                attr_reader :rxtx_factor
                # @return [Integer] Disk size (GiB)
                attr_reader :disk
                # @return [Integer] Ephemeral disk size (GiB)
                attr_reader :ephemeral
                # @return [Boolean] Whether the flavor is public
                attr_reader :is_public

                # Creates a new {FlavorItemDetail} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    super( data )

                    @ram = data['ram']
                    @vcpus = data['vcpus']
                    @swap = data['swap']
                    @rxtx_factor = data['rxtx_factor']
                    @disk = data['disk']
                    @is_public = Utility.to_b( data['os-flavor-access:is_public'] )
                    @ephemeral = data['OS-FLV-EXT-DATA:ephemeral']
                end

            end

        end

    end

end