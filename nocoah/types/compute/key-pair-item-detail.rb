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

                # Creates a new {KeyPairItemDetail} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    super( data )

                    @keypair_id = data['id']
                    @user_id = data['user_id']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @updated_at = DateTime.parse( data['updated_at'] ) rescue nil
                    @deleted = data['deleted']
                end

            end

        end

    end

end