require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Key-pair item
            class KeyPairItem < Base

                # @return [String] Key name
                attr_reader :name
                # @return [String] Public key
                attr_reader :public_key
                # @return [String] Fingerprint
                attr_reader :fingerprint

                # Creates a new {KeyPairItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @key_name = data['name']
                    @public_key = data['public_key']
                    @fingerprint = data['fingerprint']
                end

            end

        end

    end

end