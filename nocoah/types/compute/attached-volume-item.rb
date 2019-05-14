require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Attached volume item
            class AttachedVolumeItem

                # @return [String] Attachment ID
                attr_reader :attachment_id
                # @return [String] Volume device
                attr_reader :device
                # @return [String] Attached server ID
                attr_reader :server_id
                # @return [String] Attached volume ID
                attr_reader :volume_id

                def initialize( data )
                    @attachment_id = data['id']
                    @device = data['device']
                    @server_id = data['serverId']
                    @volume_id = data['volumeId']
                end

                def to_s
                    {
                        'Attachment ID' => @attachment_id,
                        'Device' => @device,
                        'Attached server ID' => @server_id,
                        'Attached volume ID' => @volume_id,
                    }.to_s
                end

            end

        end

    end

end