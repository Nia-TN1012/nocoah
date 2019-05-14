require 'date'
require_relative './key-pair-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Key-pair item detail
            class KeyPairItemDetail < KeyPairItem

                # @return [String] Key-pair ID
                attr_reader :keypair_id
                # @return [String] User ID
                attr_reader :user_id
                # @return [DateTime] Created time
                attr_reader :created_at
                # @return [DateTime] Updated time
                attr_reader :updated_at
                # @return [Boolean] Whether it has been deleted
                attr_reader :deleted

                def initialize( data )
                    super( data )

                    @keypair_id = data['id']
                    @user_id = data['user_id']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @updated_at = DateTime.parse( data['updated_at'] ) rescue nil
                    @deleted = data['deleted']
                end

                def to_s
                    {
                        'Key name' => @key_name,
                        'Public key' => @public_key,
                        'Fingerprint' => @fingerprint,
                        'Key-pair ID' => @keypair_id,
                        'User ID' => @user_id,
                        'Created time' => @created_at,
                        'Updated time' => @updated_at,
                        'Is deleted' => @deleted,
                    }.to_s
                end

            end

        end

    end

end