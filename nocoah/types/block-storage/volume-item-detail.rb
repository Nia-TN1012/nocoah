require 'date'
require_relative '../../utility'
require_relative './volume-item'
require_relative '../compute/attached-volume-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Block Storage
        module BlockStorage

            # Volume item with detail
            class VolumeItemDetail < VolumeItem

                # @return [String] Status
                attr_reader :status
                # @return [String] Availability zone
                attr_reader :availability_zone
                # @return [Boolean] Bootable
                attr_reader :bootable
                # @return [Boolean] Encrypted
                attr_reader :encrypted
                # @return [String] Volume type
                attr_reader :volume_type
                # @return [String] Description
                attr_reader :description
                # @return [Integer] Volume size (GiB)
                attr_reader :size
                # @return [String] User ID
                attr_reader :user_id
                # @return [DateTime] Create time
                attr_reader :created_at
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [String] Consistency group ID
                attr_reader :consistencygroup_id
                # @return [String] Source volume ID
                attr_reader :source_volid
                # @return [String] Snapshot ID
                attr_reader :snapshot_id
                # @return [Array<Nocoah::Types::Compute::AttachedVolumeItem>] Attachments
                attr_reader :attachments
                # @return [String] Replication status
                attr_reader :replication_status
                # @return [String] Replication status (extended)
                attr_reader :replication_extended_status
                # @return [String] Replication driver data
                attr_reader :replication_driver_data
                # @return [Hash] Volume metadata
                attr_reader :metadata

                # Creates a new {VolumeItemDetail} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    super( data )

                    @status = data['status']
                    @availability_zone = data['availability_zone']
                    @bootable = Utility.to_b( data['bootable'] )
                    @encrypted = Utility.to_b( data['encrypted'] )
                    @volume_type = data['volume_type']
                    @description = data['description']
                    @size = data['size']
                    @user_id = data['user_id']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @tenant_id = data['os-vol-tenant-attr:tenant_id']
                    @consistencygroup_id = data['consistencygroup_id']
                    @source_volid = data['source_volid']
                    @snapshot_id = data['snapshot_id']
                    @attachments = data['attachments'].map { | attachment | Compute::AttachedVolumeItem.new( attachment ) } rescue []
                    @replication_status = data['replication_status']
                    @replication_extended_status = data['os-volume-replication:extended_status']
                    @replication_driver_data = data['os-volume-replication:driver_data']
                    @metadata = data['metadata']
                end

            end

        end

    end

end