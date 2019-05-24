require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # DNS
        module DNS

            # Record item
            class RecordItem < Base

                # @return [String] Record ID
                attr_reader :record_id
                # @return [String] Domain ID
                attr_reader :domain_id
                # @return [String] Record FDQN name
                attr_reader :name
                # @return [String] Record type
                attr_reader :type
                # @return [String] Record value
                attr_reader :data
                # @return [Integer] TTL
                attr_reader :ttl
                # @return [String] Priority
                attr_reader :priority
                # @return [DateTime] Created Time
                attr_reader :created_at
                # @return [DateTime] Updated Time
                attr_reader :updated_at
                # @return [String] Remarks
                attr_reader :description
                # @return [String] GSLB region code
                attr_reader :gslb_region
                # @return [Integer] GSLB priority
                attr_reader :gslb_weight
                # @return [Integer] GSLB health check ( 0: OFF / Port number )
                attr_reader :gslb_check

                # Creates a new {RecordItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @record_id = data['id']
                    @domain_id = data['domain_id']
                    @name = data['name']
                    @ttl = data['ttl']
                    @type = data['type']
                    @data = data['data']
                    @priority = data['priority']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @updated_at = DateTime.parse( data['updated_at'] ) rescue nil
                    @description = data['description']
                    @gslb_region = data['gslb_region']
                    @gslb_weight = data['gslb_weight']
                    @gslb_check = data['gslb_check']
                end

            end

            # Record type
            module RecordType
                # A: Used when associating a domain with an IP address (IPv4)
                A = "A"
                # AAAA: Used when associating a domain with an IP address (IPv6)
                AAAA = "AAAA"
                # MX: Used for mail server
                MX="MX"
                # CNAME: Used when specifying domain name aliases
                CNAME="CNAME"
                # TXT: Used when providing text information. It is used for domain ownership and server certification (as SPF record) when sending mail.
                TXT="TXT"
                # SRV: Used when specifying a service corresponding to a domain
                SRV="SRV"
                # NS: Used when specifying name server
                NS="NS"
                # PTR: Used for reverse lookup from IP address to domain.
                PTR="PTR"
            end

            # Record type
            module GSLBRegion
                # Japan ( Tokyo )
                JP = "JP"
                # United States ( San Jose )
                US = "US"
                # Singapore
                SG = "SG"
                # Specifies this when automatically assigning GSLB regions when creating records.
                AUTO = "AUTO"
            end
            
        end

    end

end