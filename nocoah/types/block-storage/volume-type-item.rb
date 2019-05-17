require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Block Storage
        module BlockStorage

            # Volume type item
            class VolumeTypeItem < Base

                # @return [String] Volume type ID
                attr_reader :volume_type_id
                # @return [String] Volume type name
                attr_reader :name
                # @return [String] Volume backend name
                attr_reader :volume_backend_name

                # Creates a new {VolumeTypeItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @volume_type_id = data['id']
                    @name = data['name']
                    @volume_backend_name = data['extra_specs']['volume_backend_name'] rescue nil
                end

            end

        end

    end

end