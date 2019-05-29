require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/account'

# Nocoah
module Nocoah

    # Client
    module Client

        # ConoHa account API.
        class Account < Base

            # Account API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            ENDPOINT_BASE = "https://account.%s.conoha.io/v1"

            # Gets a ordered item list.
            #
            # @param          [Hash]                filters         Filters (  )
            # @option filters [String or Regexp]    :service_name   Filter by Service name
            # @option filters [String]              :item_status    Filter by Item status
            # @option filters [String]              :sort_key       Sort key ( It can also be specified from the constant list of {Types::Account::SortKeyOrderItem}. )
            # @option filters [String]              :sort_type      Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Account::OrderItem>]    When succeeded, ordered item list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_order_item_detail
            # @see https://www.conoha.jp/docs/account-order-item-list.html
            def get_order_items_list( **filters )
                raise ArgumentError, "sort_key '#{filters[:sort_key]}' is invalid." if filters.key?( :sort_key ) && !Types::Account::SortKeyOrderItem.validate_key( filters[:sort_key] )
                
                json_data = api_get( "/#{@identity.config.tenant_id}/order-items", error_message: "Failed to get order-item list." )
                return [] unless json_data.key?( 'order_items' )
                
                order_item_list = json_data['order_items'].map { | item | Types::Account::OrderItem.new( item ) }
                # Filter by Service name
                order_item_list.select! {
                    | item |
                        case filters[:service_name]
                        when Regexp
                            matched = !!item.service_name.match( filters[:service_name] )
                        else
                            matched = item.service_name == filters[:service_name]
                        end
                        matched
                } if filters.key?( :service_name )
                # Filter by Item status
                order_item_list.select! { | item | item.item_status == filters[:item_status] } if filters.key?( :item_status )
                # Sort
                order_item_list.sort_by! { | item | item.instance_variable_get( "@#{filters[:sort_key]}" ) } if filters.key?( :sort_key )
                order_item_list.reverse! if filters[:sort_type] == Types::Common::SortDirection::DESC

                order_item_list
            end

            # Gets a ordered items info.
            #
            # @param [String] item_id       Item ID
            #
            # @return [Nocoah::Types::Account::OrderItemDetail]     When succeeded, ordered item detail info.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_order_items_list
            # @see https://www.conoha.jp/docs/account-order-item-detail-specified.html
            def get_order_item_detail( item_id )
                json_data = api_get( "/#{@identity.config.tenant_id}/order-items/#{item_id}", error_message: "Failed to get order-item (item_id: #{item_id})." )
                return nil unless json_data.key?( 'order_item' )

                Types::Account::OrderItemDetail.new( json_data['order_item'] )
            end

            # Gets a payment history.
            #
            # @return [Array<Nocoah::Types::Account::PaymentHistoryItem>]   When succeeded, payment history.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_payment_summary
            # @see https://www.conoha.jp/docs/account-payment-histories.html
            def get_payment_history
                json_data = api_get( "/#{@identity.config.tenant_id}/payment-history", error_message: "Failed to get payment-history." )
                return [] unless json_data.key?( 'payment_history' )
                
                json_data['payment_history'].map() do | item |
                    Types::Account::PaymentHistoryItem.new( item )
                end
            end

            # Gets a payment summary.
            #
            # @return [Nocoah::Types::Account::PaymentSummary]  When succeeded, payment summary.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_payment_history
            # @see https://www.conoha.jp/docs/account-payment-summary.html
            def get_payment_summary
                json_data = api_get( "/#{@identity.config.tenant_id}/payment-summary", "Failed to get payment-summary." )
                return nil unless json_data.key?( 'payment_summary' )

                Types::Account::PaymentSummary.new( json_data['payment_summary'] )
            end

            # Gets a billing invoices list.
            #
            # @param            [Integer] url_query     URL query
            # @option url_query [Integer] offset        (0) Acquisition start position
            # @option url_query [Integer] limit         (1000) Acquisition number
            #
            # @return [Array<Nocoah::Types::Account::BillingInvoiceItem>]   When succeeded, billing invoices list.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_billing_invoice_detail
            # @see https://www.conoha.jp/docs/account-billing-invoices-list.html
            def get_billing_invoices_list( **url_query )
                uri = URI.parse( "/#{@identity.config.tenant_id}/billing-invoices" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                json_data = api_get( uri.to_s, error_message: "Failed to get billing-invoices list. (url_query: #{url_query})" )
                return [] unless json_data.key?( 'billing_invoices' )

                json_data['billing_invoices'].map() do | item |
                    Types::Account::BillingInvoiceItem.new( item )
                end
            end

            # Gets a billing invoice detail list.
            #
            # @param [String] invoice_id   Invoice ID
            #
            # @return [Array<Nocoah::Types::Account::BillingInvoiceDetailItem>]     When succeeded, billing invoice detail list.
            # @raise [Nocoah::APIError]                                             When failed.
            #
            # @see get_billing_invoices_list
            # @see https://www.conoha.jp/docs/account-billing-invoices-detail-specified.html
            def get_billing_invoice_detail( invoice_id )
                json_data = api_get( "/#{@identity.config.tenant_id}/billing-invoices/#{invoice_id}", error_message: "Failed to get billing-invoice detail item (invoice_id: #{invoice_id})." )
                return [] unless json_data.key?( 'billing_invoice' ) || !json_data['billing_invoice'].key?( 'items' )

                json_data['billing_invoice']['items'].map() do | item |
                    Types::Account::BillingInvoiceDetailItem.new( item )
                end
            end

            # Gets a notifications list.
            #
            # @param            [Integer] url_query     URL query
            # @option url_query [Integer] offset        (0) Acquisition start position
            # @option url_query [Integer] limit         (1000) Acquisition number
            #
            # @return [Array<Nocoah::Types::Account::NotificationItem>]     When succeeded, notifications list.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_notification_item
            # @see https://www.conoha.jp/docs/account-informations-list.html
            def get_notifications_list( **url_query )
                uri = URI.parse( "/#{@identity.config.tenant_id}/notifications" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                json_data = api_get( uri.to_s, error_message: "Failed to get notifications list. (url_query: #{url_query})" )
                return [] unless json_data.key?( 'notifications' )

                json_data['notifications'].map() do | item |
                    Types::Account::NotificationItem.new( item )
                end
            end

            # Gets a notification item.
            #
            # @param [String] notification_code   Notification code
            #
            # @return [Nocoah::Types::Account::NotificationItem]    When succeeded, notification item.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_notifications_list
            # @see https://www.conoha.jp/docs/account-informations-detail-specified.html
            def get_notification_item( notification_code )
                json_data = api_get( "/#{@identity.config.tenant_id}/notifications/#{notification_code}", error_message: "Failed to get notification item (notification_code: #{notification_code})." )
                return nil unless json_data.key?( 'notification' )

                Types::Account::NotificationItem.new( json_data['notification'] )
            end

            # Sets read status of the notification
            #
            # @param [String]   notification_code   Notification code
            # @param [String]   read_status         Read / Unread status ( It can also be specified from the constant list of {Nocoah::Types::Account::ReadStatus}. )
            #
            # @return [Nocoah::Types::Account::NotificationItem]    When succeeded, notification info.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/account-informations-marking.html
            def set_read_status_notification( notification_code, read_status )
                body = {
                    notification: {
                        read_status: read_status,
                    }
                }
        
                json_data = api_post( "/#{@identity.config.tenant_id}/notifications/#{notification_code}", body: body, error_message: "Failed to set read status (notification_code: #{notification_code})." )
                return nil unless json_data.key?( 'notification' )

                Types::Account::NotificationItem.new( json_data['notification'] )
            end

            # Gets a object storage request utilization rrd.
            #
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' ) ( It can also be specified from the constant list of {Nocoah::Types::Common::RRDMode}. )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, object storage request utilization rrd.
            # @raise [Nocoah::APIError]                 When failed.
            #
            # @see https://www.conoha.jp/docs/account-get_objectstorage_request_rrd.html
            def get_object_storage_request_rrd( **url_query )
                get_object_storage_rrd_core( "request", url_query )
            end

            # Gets a object storage size utilization rrd.
            #
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' ) ( It can also be specified from the constant list of {Nocoah::Types::Common::RRDMode}. )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, object storage size utilization rrd.
            # @raise [Nocoah::APIError]                 When failed.
            #
            # @see https://www.conoha.jp/docs/account-get_objectstorage_size_rrd.html
            def get_object_storage_size_rrd( **url_query )
                get_object_storage_rrd_core( "size", url_query )
            end

            private

            # Gets a object storage utilization rrd.
            #
            # @param            [String]    target_rrd          Target RRD ( 'request' or 'size' )
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' ) ( It can also be specified from the constant list of {Nocoah::Types::Common::RRDMode}. )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, object storage utilization rrd.
            # @raise [Nocoah::APIError]                 When failed.
            def get_object_storage_rrd_core( target_rrd, **url_query )
                # When specified in Date, Time or DateTime type, converts to UNIX time.
                url_query[:start_date_raw] = url_query[:start_date_raw].to_i if Types::Common.kind_of_date_or_time?( url_query[:start_date_raw] )
                url_query[:end_date_raw] = url_query[:end_date_raw].to_i if Types::Common.kind_of_date_or_time?( url_query[:end_date_raw] )

                uri = URI.parse( "/#{@identity.config.tenant_id}/object-storage/rrd/#{target_rrd}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?
        
                json_data = api_get( uri.to_s, "Failed to get object storage #{target_rrd} utilization rrd (url_query: #{url_query})." )
                return nil unless json_data.key?( target_rrd )

                Types::Common::RRD.new( target_rrd, json_data[target_rrd] )
            end

        end
    
    end

end