require 'date'

# Nocoah
module Nocoah

    # Types
    module Types

        # Image
        module Image

            # Image member item
            class MemberItem < Base

                # @return [String] Member ID
                attr_reader :member_id
                # @return [String] Image ID
                attr_reader :image_id
                # @return [String] Status
                attr_reader :status
                # @return [Datetime] Created time
                attr_reader :created_at
                # @return [Datetime] Updated time
                attr_reader :updated_at
                # @return [String] Image member schema url
                attr_reader :schema

                # Creates a new {MemberItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @member_id = data['member_id']
                    @image_id = data['image_id']
                    @status = data['status']
                    @created_at = DateTime.parse( data['created_at'] )
                    @updated_at = DateTime.parse( data['updated_at'] )
                    @schema = data['schema']
                end

            end

            # Member status
            module MemberStatus
                # Accepted
                ACCEPTED = "accepted"
                # Pending
                PENDING = "pending"
                # Rejected
                REJECTED = "rejected"
                # ( For filtering ) ALL member status
                ALL = "all"
            end

        end

    end

end