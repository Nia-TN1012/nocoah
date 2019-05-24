require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/dns'

# Nocoah
module Nocoah

    # Client
    module Client

        # DNS API
        #
        # @see https://support.conoha.jp/v/geodns/
        class DNS < Base

            # Database API Endpoint ( '%s' contains a string representing the region. )
            ENDPOINT_BASE = "https://dns-service.%s.conoha.io/v1"

            # Gets a domain list
            #
            # @param [String] domain_name   Domain name
            #
            # @return [Array<Nocoah::Types::DNS::DomainItem>]   When succeeded, domain list.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_domain_item
            # @see https://www.conoha.jp/docs/paas-dns-list-domains.html
            def get_domain_list( domain_name: nil )
                uri = URI.parse( "/domains" )
                uri.query = URI.encode_www_form( { name: domain_name } ) if !domain_name.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get domain list (domain_name: #{domain_name})." )
                return [] unless json_data.key?( 'domains' )

                json_data['domains'].map { | domain | Types::DNS::DomainItem.new( domain ) }
            end

            # Gets a domain item.
            #
            # @param [String] domain_id    Domain ID
            #
            # @return [Nocoah::Types::DNS::DomainItem]      When succeeded, domain item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see get_domain_list
            # @see https://www.conoha.jp/docs/paas-dns-get-a-domain.html
            def get_domain_item( domain_id )
                json_data = api_get( "/domains/#{domain_id}", error_message: "Failed to get domain item (domain_id: #{domain_id})." )
                return nil if json_data.empty?

                Types::DNS::DomainItem.new( json_data )
            end

            # Creates a new domain.
            #
            # @param          [String]      domain_name         Domain name
            # @param          [String]      email               Email
            # @param          [Hash]        options             Options
            # @option options [Integer]     :ttl                (60) TTL (sec.)
            # @option options [String]      :description        ("") Remarks
            # @option options [Integer]     :gslb               (0) Enables GSLB ( 0: OFF / 1: ON )
            #
            # @example
            #   create_domain(
            #       "domain1.com.",
            #       "nsadmin@example.org",
            #       ttl: 3600,
            #       gslb: 0
            #   )
            #
            # @return [Nocoah::Types::DNS::DomainItem]      When succeeded, created domain item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-dns-create-domain.html
            # @see https://www.conoha.jp/vps/pricing/
            def create_domain( domain_name, email, **options )
                options_2 = options.dup
                options_2[:ttl] ||= 60
                options_2[:gslb] ||= 0
                options_2[:name] = domain_name
                options_2[:email] = email
                json_data = api_post(
                    "/domains",
                    body: options_2,
                    error_message: "Failed to create domain (domain_name: #{domain_name}, email: #{email}, options: #{options})." 
                )
                return nil if json_data.empty?

                Types::DNS::DomainItem.new( json_data )
            end

            # Updates the domain.
            #
            # @param          [String]      domain_id           Domain ID
            # @param          [Hash]        options             Options
            # @option options [String]      :email              Email address
            # @option options [Integer]     :ttl                TTL (sec.)
            # @option options [String]      :description        Remarks
            # @option options [Integer]     :gslb               Enables GSLB ( 0: OFF / 1: ON )
            #
            # @return [Nocoah::Types::Database::DatabaseItem]   When succeeded, updated domain item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-dns-update-a-domain.html
            def update_domain( domain_id, **options )
                json_data = api_put(
                    "/domains/#{domain_id}",
                    body: options,
                    error_message: "Failed to update domain (domain_id: #{domain_id}, options: #{options})." 
                )
                return nil if json_data.empty?

                Types::DNS::DomainItem.new( json_data )
            end

            # Deletes the domain.
            #
            # @param [String] domain_id     Domain ID
            #
            # @return [String]              When succeeded, deleted domain ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-dns-delete-a-domain.html
            def delete_domain( domain_id )
                api_delete( 
                    "/domains/#{domain_id}",
                    error_message: "Failed to delete domain (domain_id: #{domain_id})."
                ) do | res |
                    domain_id
                end
            end

            # Gets a name server list.
            #
            # @param [String] domain_id    Domain ID
            #
            # @return [Nocoah::Types::DNS::NameServerItem]      When succeeded, name server list.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_domain_list
            # @see https://www.conoha.jp/docs/paas-dns-get-a-domain.html
            def get_domain_hosting_list( domain_id )
                json_data = api_get( "/domains/#{domain_id}/servers", error_message: "Failed to get name server list (domain_id: #{domain_id})." )
                return nil if json_data.empty?

                return [] unless json_data.key?( 'servers' )

                json_data['servers'].map { | server | Types::DNS::NameServerItem.new( server ) }
            end

            # Gets a domain record list
            #
            # @param [String] domain_id   Domain ID
            #
            # @return [Array<Nocoah::Types::DNS::RecordItem>]   When succeeded, domain record list.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_record_item
            # @see https://www.conoha.jp/docs/paas-dns-list-records-in-a-domain.html
            def get_record_list( domain_id )
                json_data = api_get(
                    "/domains/#{domain_id}/records",
                    error_message: "Failed to get domain record list (domain_id: #{domain_id})."
                )
                return [] unless json_data.key?( 'records' )

                json_data['records'].map { | record | Types::DNS::RecordItem.new( record ) }
            end

            # Gets a domain record item.
            #
            # @param [String] domain_id    Domain ID
            # @param [String] record_id    Record ID
            #
            # @return [Nocoah::Types::DNS::RecordItem]      When succeeded, domain record item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see get_record_list
            # @see https://www.conoha.jp/docs/paas-dns-get-a-record.html
            def get_record_item( domain_id, record_id )
                json_data = api_get(
                    "/domains/#{domain_id}/records/#{record_id}",
                    error_message: "Failed to get domain record item (domain_id: #{domain_id})."
                )
                return nil if json_data.empty?

                Types::DNS::RecordItem.new( json_data )
            end

            # Creates a new domain record.
            #
            # @param          [String]      domain_id           Domain ID
            # @param          [String]      record_name         Record name
            # @param          [String]      type                Record type ( It can also be specified from the constant list of {Types::DNS::RecordType}. )
            # @param          [String]      data                Record value
            # @param          [Integer]     priority            Priority ( required when record type is MX or SRV )
            # @param          [Hash]        options             Options
            # @option options [Integer]     :ttl                (60) TTL (sec.)
            # @option options [String]      :description        ("") Remarks
            # @option options [String]      :gslb_region        GSLB region code ( 'JP', 'US', 'SG' or 'AUTO' ) ( It can also be specified from the constant list of {Types::DNS::GSLBRegion}. )
            # @option options [Integer]     :gslb_weight        GSLB priority ( 0 to 255 )
            # @option options [Integer]     :gslb_check         GSLB health check ( 0: OFF / Port number )
            #
            # @example
            #   create_domain(
            #       "89acac79-38e7-497d-807c-a011e1310438",
            #       "www.example.com.",
            #       type: "A",
            #       data: "192.0.2.3"
            #       gslb_check: 1,
            #       gslb_region: "JP",
            #       gslb_weight: 250,
            #   )
            #
            # @return [Nocoah::Types::DNS::RecordItem]      When succeeded, created domain record item.
            # @raise [ArgementError]                        When priority is specified nil ( when type is specified MX or SRV ).
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-dns-create-record.html
            def create_record( domain_id, record_name, type:, data:, priority: nil, **options )
                raise ArgumentError, "You must specify a valid value for priority when type is specified MX or SRV." \
                    if ( type == Types::DNS::RecordType::MX || type == Types::DNS::RecordType::SRV ) && priority.nil?
                priority ||= 0

                options_2 = options.dup
                options_2[:ttl] ||= 60
                options_2[:name] = record_name
                options_2[:type] = type
                options_2[:data] = data
                options_2[:priority] = priority

                json_data = api_post(
                    "/domains/#{domain_id}/records",
                    body: options_2,
                    error_message: "Failed to create domain record (domain_id: #{domain_id}, record_name: #{record_name}, type: #{type}, data: #{data}, priority: #{priority}, options: #{options})." 
                )
                return nil if json_data.empty?

                Types::DNS::RecordItem.new( json_data )
            end

            # Updates the domain recoed.
            #
            # @param          [String]      domain_id           Domain ID
            # @param          [String]      record_id           Record ID
            # @param          [Hash]        options             Options
            # @option options [String]      :name               Record name
            # @option options [String]      :type               Record type ( It can also be specified from the constant list of {Types::DNS::RecordType}. )
            # @option options [String]      :data               Record value
            # @option options [Integer]     :priority           Priority
            # @option options [Integer]     :ttl                TTL (sec.)
            # @option options [String]      :description        Remarks
            # @option options [String]      :gslb_region        GSLB region code ( 'JP', 'US', 'SG' or 'AUTO' ) ( It can also be specified from the constant list of {Types::DNS::GSLBRegion}. )
            # @option options [Integer]     :gslb_weight        GSLB priority ( 0 to 255 )
            # @option options [Integer]     :gslb_check         GSLB health check ( 0: OFF / Port number )
            #
            # @return [Nocoah::Types::DNS::RecordItem]      When succeeded, updated domain record item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-dns-update-a-record.html
            def update_record( domain_id, record_id, **options )
                json_data = api_put(
                    "/domains/#{domain_id}/records/#{record_id}",
                    body: options,
                    error_message: "Failed to update domain record (domain_id: #{domain_id}, record_id: #{record_id}, options: #{options})." 
                )
                return nil if json_data.empty?

                Types::DNS::RecordItem.new( json_data )
            end

            # Deletes the domain record.
            #
            # @param [String] domain_id    Domain ID
            # @param [String] record_id    Record ID
            #
            # @return [String]              When succeeded, deleted record ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-dns-delete-a-record.html
            def delete_record( domain_id, record_id )
                api_delete( 
                    "/domains/#{domain_id}/records/#{record_id}",
                    error_message: "Failed to delete domain record (domain_id: #{domain_id}, record_id: #{record_id})."
                ) do | res |
                    record_id
                end
            end

        end

    end

end