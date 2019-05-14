# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Key-pair item
            class KeyPairItem

                # @return [String] Key name
                attr_reader :name
                # @return [String] Public key
                attr_reader :public_key
                # @return [String] Fingerprint
                attr_reader :fingerprint

                def initialize( data )
                    @key_name = data['name']
                    @public_key = data['public_key']
                    @fingerprint = data['fingerprint']
                end

                def to_s
                    {
                        'Key name' => @key_name,
                        'Public key' => @public_key,
                        'Fingerprint' => @fingerprint,
                    }.to_s
                end

            end

        end

    end

end