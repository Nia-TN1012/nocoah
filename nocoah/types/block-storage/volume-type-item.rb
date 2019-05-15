# Nocoah
module Nocoah

    # Types
    module Types

        # Block Storage
        module BlockStorage

            # Volume type item
            class VolumeTypeItem

                # @return [String] Volume type ID
                attr_reader :volume_type_id
                # @return [String] Volume type name
                attr_reader :name
                # @return [String] Volume backend name
                attr_reader :volume_backend_name

                def initialize( data )
                    @volume_type_id = data['id']
                    @name = data['name']
                    @volume_backend_name = data['extra_specs']['volume_backend_name'] rescue nil
                end

                def to_s
                    {
                        'Volume type ID' => @volume_type_id,
                        'Volume type name' => @name,
                        'Volume backend name' => @volume_backend_name,
                    }.to_s
                end

            end

        end

    end

end