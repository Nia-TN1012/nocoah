# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Image metadata
            class ImageMetadata

                # @return [String] App name
                attr_reader :app
                # @return [String] Distribution name
                attr_reader :dst
                # @return [Integer] Display order
                attr_reader :display_order
                # @return [String] Whether supports Guest Agent
                attr_reader :hw_qemu_guest_agent
                # @return [String] OS type
                attr_reader :os_type

                def initialize( data )
                    @app = data['app']
                    @dst = data['dst']
                    @display_order = data['display_order']
                    @hw_qemu_guest_agent = data['hw_qemu_guest_agent']
                    @os_type = data['os_type']
                end

                def to_s
                    {
                        'App name' => @app,
                        'Distribution name' => @dst,
                        'Display order' => @display_order,
                        'Guest Agent support' => @hw_qemu_guest_agent,
                        'OS type' => @os_type,
                    }.to_s
                end

            end

        end

    end

end