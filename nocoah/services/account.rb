require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/account'

# Nocoah
module Nocoah

    # Services
    module Services

        # ConoHa account API.
        class Account < Base

            # Account API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            ENDPOINT_BASE = "https://account.%s.conoha.io/v1"

            # Gets ordered items list.
            #
            # @return [Array<Nocoah::Types::Account::OrderItem>]    When succeeded, ordered items list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_order_item_detail
            # @see https://www.conoha.jp/docs/account-order-item-list.html
            def get_order_items_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/order-items", header: headers )
                raise APIError, message: "Failed to get order-items list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'order_items' )
                
                json_data['order_items'].map() do | item |
                    Types::Account::OrderItem.new( item )
                end
            end

            # Gets ordered items info.
            #
            # @param [String] item_id       Item ID
            #
            # @return [Nocoah::Types::Account::OrderItemDetail]     When succeeded, ordered item detail info.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_order_items_list
            # @see https://www.conoha.jp/docs/account-order-item-detail-specified.html
            def get_order_item_detail( item_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/order-items/#{item_id}", header: headers )
                raise APIError, message: "Failed to get order-item info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'order_item' )

                Types::Account::OrderItemDetail.new( json_data['order_item'] )
            end

            # Gets payment history.
            #
            # @return [Array<Nocoah::Types::Account::PaymentHistoryItem>]   When succeeded, payment history.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_payment_summary
            # @see https://www.conoha.jp/docs/account-payment-histories.html
            def get_payment_history
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/payment-history", header: headers )
                raise APIError, message: "Failed to get payment-history.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'payment_history' )
                
                json_data['payment_history'].map() do | item |
                    Types::Account::PaymentHistoryItem.new( item )
                end
            end

            # Gets payment summary.
            #
            # @return [Nocoah::Types::Account::PaymentSummary]  When succeeded, payment summary.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_payment_history
            # @see https://www.conoha.jp/docs/account-payment-summary.html
            def get_payment_summary
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/payment-summary", header: headers )
                raise APIError, message: "Failed to get payment-summary.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'payment_summary' )

                Types::Account::PaymentSummary.new( json_data['payment_summary'] )
            end

            # Gets billing invoices list.
            #
            # @param [Integer] offset   Acquisition start position
            # @param [Integer] limit    Acquisition number
            #
            # @return [Array<Nocoah::Types::Account::BillingInvoiceItem>]   When succeeded, billing invoices list.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_billing_invoice_detail
            # @see https://www.conoha.jp/docs/account-billing-invoices-list.html
            def get_billing_invoices_list( offset: 0, limit: 1000 )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/billing-invoices?offset=#{offset}&limit=#{limit}", header: headers )
                raise APIError, message: "Failed to get billing-invoices list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'billing_invoices' )

                json_data['billing_invoices'].map() do | item |
                    Types::Account::BillingInvoiceItem.new( item )
                end
            end

            # Gets billing invoice detail list.
            #
            # @param [String] invoice_id   Invoice ID
            #
            # @return [Array<Nocoah::Types::Account::BillingInvoiceDetailItem>]     When succeeded, billing invoice detail list.
            # @raise [Nocoah::APIError]                                             When failed.
            #
            # @see get_billing_invoices_list
            # @see https://www.conoha.jp/docs/account-billing-invoices-detail-specified.html
            def get_billing_invoice_detail( invoice_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/billing-invoices/#{invoice_id}", header: headers )
                raise APIError, message: "Failed to get billing-invoice detail info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'billing_invoice' ) || !json_data['billing_invoice'].key?( 'items' )

                json_data['billing_invoice']['items'].map() do | item |
                    Types::Account::BillingInvoiceDetailItem.new( item )
                end
            end

            # Gets notifications list.
            #
            # @param [Integer] offset   Acquisition start position
            # @param [Integer] limit    Acquisition number
            #
            # @return [Array<Nocoah::Types::Account::NotificationItem>]     When succeeded, notifications list.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_notification_item
            # @see https://www.conoha.jp/docs/account-informations-list.html
            def get_notifications_list( offset: 0, limit: 1000 )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/notifications?offset=#{offset}&limit=#{limit}", header: headers )
                raise APIError, message: "Failed to get notifications list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'notifications' )

                json_data['notifications'].map() do | item |
                    Types::Account::NotificationItem.new( item )
                end
            end

            # Gets notification item.
            #
            # @param [String] notification_code   Notification code
            #
            # @return [Nocoah::Types::Account::NotificationItem]    When succeeded, notification item.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_notifications_list
            # @see https://www.conoha.jp/docs/account-informations-detail-specified.html
            def get_notification_item( notification_code )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/#{@identity.config.tenant_id}/notifications/#{notification_code}", header: headers )
                raise APIError, message: "Failed to get notification info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'notification' )

                Types::Account::NotificationItem.new( json_data['notification'] )
            end

            # Sets read status of notification
            #
            # @param [String]   notification_code   Notification code
            # @param [String]   read_status         Read / Unread status ( You can specify the enumerator of {Nocoah::Types::Account::ReadStatus} as an alias. )
            #
            # @return [Nocoah::Types::Account::NotificationItem]    When succeeded, notification info.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/account-informations-marking.html
            def set_read_status_notification( notification_code, read_status )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    notification: {
                        read_status: read_status,
                    }
                }.to_json

                http_client = HTTPClient.new;
                res = http_client.put( "#{@endpoint}/#{@identity.config.tenant_id}/notifications/#{notification_code}", header: headers, body: body )
                raise APIError, message: "Failed to get notification info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'notification' )

                Types::Account::NotificationItem.new( json_data['notification'] )
            end

            # Gets object storage request utilization rrd.
            #
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' )
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

            # Gets object storage size utilization rrd.
            #
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' )
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

            # Gets object storage utilization rrd.
            #
            # @param            [String]    target_rrd          Target RRD ( 'request' or 'size' )
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, object storage utilization rrd.
            # @raise [Nocoah::APIError]                 When failed.
            def get_object_storage_rrd_core( target_rrd, **url_query )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                
                # When specified in Date, Time or DateTime type, converts to UNIX time.
                url_query[:start_date_raw] = url_query[:start_date_raw].to_i if Types::Common.kind_of_date_or_time?( url_query[:start_date_raw] )
                url_query[:end_date_raw] = url_query[:end_date_raw].to_i if Types::Common.kind_of_date_or_time?( url_query[:end_date_raw] )

                uri = URI.parse( "#{@endpoint}/#{@identity.config.tenant_id}/object-storage/rrd/#{target_rrd}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                http_client = HTTPClient.new;
                res = http_client.get( uri, header: headers )
                raise APIError, message: "Failed to get object storage #{target_rrd} utilization rrd.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( target_rrd )

                Types::Common::RRD.new( target_rrd, json_data[target_rrd] )
            end

        end
    
    end

end