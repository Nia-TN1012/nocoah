require_relative './key-pair-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Stores the result when key-pair is added.
            class AddKeyPairResult < KeyPairItem

                # @return [String] User ID
                attr_reader :user_id
                # @return [String] Private key
                # @note This attribute is stored only when the key is generated by Nova.
                attr_reader :private_key

                def initialize( data )
                    super( data )

                    @user_id = data['user_id']
                    @private_key = data['private_key']
                end

                def to_s
                    {
                        'Key name' => @key_name,
                        'Public key' => @public_key,
                        'Fingerprint' => @fingerprint,
                        'User ID' => @user_id,
                        'Private key' => @private_key,
                    }.to_s
                end

            end

        end

    end

end