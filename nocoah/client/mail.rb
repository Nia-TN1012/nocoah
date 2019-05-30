require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/mail'

# Nocoah
module Nocoah

    # Client
    module Client

        # Mail API
        #
        # @see https://support.conoha.jp/v/mailserver/
        class Mail < Base

            # Endpoint key
            ENDPOINT_KEY = :mail

            # Gets a service list.
            #
            # @param            [Hash]      url_query       URL query         
            # @option url_query [Integer]   :offset         Offset
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Mail::SortKeyService}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Mail::ServiceItem>]     When succeeded, service list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_service_item
            # @see https://www.conoha.jp/docs/paas-mail-list-mail-service.html
            def get_service_list( **url_query )
                uri = URI.parse( "/services" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get service list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'services' )

                json_data['services'].map { | service | Types::Mail::ServiceItem.new( service ) }
            end

            # Gets a service item.
            #
            # @param [String] service_id    Service ID
            #
            # @return [Nocoah::Types::Mail::ServiceItem]    When succeeded, service item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see get_service_list
            # @see https://www.conoha.jp/docs/paas-mail-get-service.html
            def get_service_item( service_id )
                json_data = api_get( "/services/#{service_id}", error_message: "Failed to get service item (service_id: #{service_id})." )
                return nil unless json_data.key?( 'service' )

                Types::Mail::ServiceItem.new( json_data['service'] )
            end

            # Creates a new service.
            #
            # @param [String]   service_name            Service name
            # @param [String]   default_sub_domain      Default sub domain
            # @param [Hash]     metadata                Metadata
            #
            # @example
            #   create_service(
            #       "testservice",
            #       default_sub_domain: "default",
            #       metadata: {
            #           key: value
            #       }
            #   )
            #
            # @return [Nocoah::Types::Mail::ServiceItem]    When succeeded, created service item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-mail-service.html
            # @see https://www.conoha.jp/vps/pricing/
            def create_service( service_name, default_sub_domain:, metadata: {} )
                json_data = api_post(
                    "/services",
                    body: {
                        service_name: service_name,
                        default_sub_domain: default_sub_domain,
                        metadata: metadata
                    },
                    error_message: "Failed to create service (service_name: #{service_name}, default_sub_domain: #{default_sub_domain}, metadata: #{metadata})." 
                )
                return nil unless json_data.key?( 'service' )

                Types::Mail::ServiceItem.new( json_data['service'] )
            end

            # Updates the service.
            #
            # @param [String]   service_id          Service ID
            # @param [String]   service_name        Service name
            # @param [Hash]     metadata            Metadata
            #
            # @return [Nocoah::Types::Mail::ServiceItem]    When succeeded, updated service item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-mail-service.html
            def update_service( service_id, service_name: nil, metadata: nil )
                body = {}
                body[:service_name] = service_name if !service_name.nil?
                body[:metadata] = metadata if !metadata.nil?
                json_data = api_put(
                    "/services/#{service_id}",
                    body: body,
                    error_message: "Failed to update service (service_id: #{service_id}, service_name: #{service_name}, metadata: #{metadata})." 
                )
                return nil unless json_data.key?( 'service' )

                Types::Mail::ServiceItem.new( json_data['service'] )
            end

            # Updates the service metadata.
            #
            # @param [String]   service_id          Service ID
            # @param [Hash]     metadata            Metadata
            #
            # @return [Hash]                When succeeded, updated service metadata.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-mail-service-metadata.html
            def update_service_metadata( service_id, metadata: )
                api_put(
                    "/services/#{service_id}/metadata",
                    body: {
                        metadata: metadata
                    },
                    error_message: "Failed to update service metadata (service_id: #{service_id}, metadata: #{metadata})."
                    )
                json_data['metadata']
            end

            # Deletes the service.
            #
            # @param [String] service_id    Service ID
            #
            # @return [String]              When succeeded, deleted service ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-delete-mail-service.html
            def delete_service( service_id )
                api_delete(
                    "/services/#{service_id}/metadata",
                    error_message: "Failed to delete service (service_id: #{service_id})."
                ) do | res |
                    service_id
                end
            end

            # Gets quota and total usage of the service.
            #
            # @param [String] service_id    Service ID
            #
            # @return [Hash]                When succeeded, :quota and :total_usage. 
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-get-email-quotas.html
            def get_service_quota( service_id )
                json_data = api_get( "/services/#{service_id}/quotas", error_message: "Failed to get service quota (service_id: #{service_id})." )
                return nil unless json_data.key?( 'quota' )

                json_data['quota']
            end

            # Sets quota of the service.
            #
            # @param [String]   service_id      Service ID
            # @param [Integer]  quota           Quota (GB)
            #
            # @return [Hash]                When succeeded, :quota and :total_usage. 
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-quotas.html
            # @see https://www.conoha.jp/vps/pricing/
            def set_service_quota( service_id, quota: )
                json_data = api_get(
                    "/services/#{service_id}/quotas",
                    body: {
                        quota: quota
                    },
                    error_message: "Failed to set service quota (service_id: #{service_id})."
                )
                return nil unless json_data.key?( 'quota' )

                json_data['quota']
            end

            # Sets the service backup.
            #
            # @param [String]               service_id      Service ID
            # @param [String or Boolean]    enabled         When "enable" or true, enables backup
            #
            # @return [String]              When succeeded, updated service ID. 
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-backup.html
            # @see https://www.conoha.jp/vps/pricing/
            def set_mail_backup( service_id, enabled: )
                case enabled.class
                when TrueClass
                    backup = "enable"
                when FalseClass
                    backup = "disable"
                else
                    backup = enabled
                end
                api_put(
                    "/services/#{service_id}/action",
                    body: {
                        backup: {
                            status: backup
                        }
                    },
                    error_message: "Failed to set mail backup (service_id: #{service_id}, enabled: #{enabled})."
                ) do | res |
                    service_id
                end
            end

            # Gets a domain list.
            #
            # @param            [Hash]      url_query       URL query
            # @option url_query [String]    :service_id     Filter by service ID      
            # @option url_query [Integer]   :offset         Offset
            # @option url_query [Integer]   :limit          Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Mail::SortKeyDomain}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Mail::DomainItem>]      When succeeded, domain list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-list-domain.html
            def get_domain_list( **url_query )
                uri = URI.parse( "/domains" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get domain list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'domains' )

                json_data['domains'].map { | domain | Types::Mail::DomainItem.new( domain ) }
            end

            # Creates a new domain.
            #
            # @param  [String] service_id       Service ID
            # @param  [String] domain_name      Domain name
            #
            # @example
            #   create_domain(
            #       "(service_id)",
            #       domain_name: "example.com"
            #   )
            #
            # @return [Nocoah::Types::Mail::DomainItem]     When succeeded, created domain item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-domain.html
            def create_domain( service_id, domain_name: )
                json_data = api_post(
                    "/domains",
                    body: {
                        service_id: service_id,
                        domain_name: db_name
                    },
                    error_message: "Failed to create domain (service_id: #{service_id}, domain_name: #{domain_name})." 
                )
                return nil unless json_data.key?( 'domain' )

                Types::Mail::DomainItem.new( json_data['domain'] )
            end

            # Deletes the domain.
            #
            # @param [String] domain_id     Domain ID
            #
            # @return [String]              When succeeded, deleted domain ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-delete-domain.html
            def delete_domain( domain_id )
                api_delete( 
                    "/domains/#{domain_id}",
                    error_message: "Failed to delete domain (domain_id: #{domain_id})."
                ) do | res |
                    domain_id
                end
            end

            # Gets a dedicated IP address.
            #
            # @param [String] domain_id     Domain ID
            #
            # @return [String]              When succeeded, dedicated IP address.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-get-dedicated-ip.html
            def get_domain_dedicated_ip( domain_id )
                json_data = api_get( "/domains/#{domain_id}/dedicatedip", error_message: "Failed to get dedicated ip (domain_id: #{domain_id})." )
                json_data['dedicatedip']
            end

            # Sets the dedicated IP address.
            #
            # @param [String]               domain_id       Domain ID
            # @param [String or Boolean]    enabled         When "enable" or true, dedicates
            #
            # @return [String]              When succeeded, dedicated IP address.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-dedicated-ip.html
            def set_domain_dedicated_ip( domain_id, enabled: )
                json_data = api_put(
                    "/domains/#{domain_id}/action",
                    body: {
                        dedicatedip: {
                            status: convert_status( enabled )
                        }
                    },
                    error_message: "Failed to set dedicated ip (domain_id: #{domain_id}, enabled: #{enabled})."
                )
                json_data['dedicatedip']
            end

            # Gets a DKIM info.
            #
            # @param [String] domain_id     Domain ID
            #
            # @return [Nocoah::Types::Mail::DKIM]   When succeeded, DKIM info.
            # @raise [Nocoah::APIError]             When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-get-dkim.html
            def get_domain_dkim( domain_id )
                json_data = api_get( "/domains/#{domain_id}/dkim", error_message: "Failed to get DKIM info. (domain_id: #{domain_id})." )
                return nil unless json_data.key?( 'dkim' )

                Types::Mail::DKIM.new( json_data['dkim'] )
            end

            # Sets the DKIM.
            #
            # @param [String]               domain_id       Domain ID
            # @param [String or Boolean]    enabled         When "enable" or true, enables DKIM
            #
            # @return [String]              When succeeded, updated domain ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-dkim.html
            def set_domain_dkim( domain_id, enabled: )
                api_put(
                    "/domains/#{domain_id}/action",
                    body: {
                        dkim: {
                            status: convert_status( enabled )
                        }
                    },
                    error_message: "Failed to set dkim (domain_id: #{domain_id}, enabled: #{enabled})."
                ) do | res |
                    domain_id
                end
            end

            # Gets a email account list.
            #
            # @param            [Hash]      url_query       URL query
            # @option url_query [String]    :domain_id      Filter by domain ID      
            # @option url_query [Integer]   :offset         (0) Offset
            # @option url_query [Integer]   :limit          (1000 Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Mail::SortKeyEmail}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Mail::EmailItem>]       When succeeded, email account list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_email_item
            # @see https://www.conoha.jp/docs/paas-mail-list-email-domains.html
            def get_email_list( **url_query )
                uri = URI.parse( "/emails" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get email account list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'emails' )

                json_data['emails'].map { | email | Types::Mail::EmailItem.new( email ) }
            end

            # Gets a email account item.
            #
            # @param [String] email_id    Email ID
            #
            # @return [Nocoah::Types::Mail::MailAddressItem]    When succeeded, email account item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_email_list
            # @see https://www.conoha.jp/docs/paas-mail-get-email.html
            def get_email_item( email_id )
                json_data = api_get( "/emails/#{email_id}", error_message: "Failed to get email account item (email_id: #{email_id})." )
                return nil unless json_data.key?( 'email' )

                Types::Mail::EmailItem.new( json_data['email'] )
            end

            # Creates a new email account.
            #
            # @param  [String] domain_id        Domain ID
            # @param  [String] email            Mail address
            # @param  [String] password         Password
            #
            # @example
            #   create_email(
            #       "(domain_id)",
            #       email: "test@example.com",
            #       password: "ZE!Zr0vKO"
            #   )
            #
            # @return [Nocoah::Types::Mail::EmailItem]      When succeeded, created email account item.
            # @raise [Nocoah::APIError]                     When failed. ( For security reasons, password in the error message will be ******. )
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-email.html
            def create_email( domain_id, email:, password: )
                json_data = api_post(
                    "/emails",
                    body: {
                        domain_id: domain_id,
                        email: email,
                        password: password
                    },
                    error_message: "Failed to create email account (domain_id: #{domain_id}, email: #{email}, password: ******)." 
                )
                return nil unless json_data.key?( 'email' )

                Types::Mail::EmailItem.new( json_data['email'] )
            end

            # Updates the email password.
            #
            # @param [String] email_id          Email ID
            # @param [String] password          New password
            #
            # @return [String]              When succeeded, updated email account ID.
            # @raise [Nocoah::APIError]     When failed. ( For security reasons, password in the error message will be ******. )
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-password.html
            def update_email_password( email_id, password: )
                api_put(
                    "/emails/#{email_id}",
                    body: {
                        password: password
                    },
                    error_message: "Failed to update password in email account (email_id: #{email_id}, password: ******)." 
                ) do | res |
                    email_id
                end
            end

            # Sets the email password.
            #
            # @param [String]               email_id        Email ID
            # @param [String or Boolean]    enabled         When "enable" or true, enables spam filter
            # @param [String]               type            Spam filter type ( 'subject' or 'tray' ) ( It can also be specified from the constant list of {Types::Mail::SpamFilterType}. )
            #
            # @return [String]              When succeeded, updated email account ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-email-spam-filter.html
            def set_email_spam_filter( email_id, enabled:, type: )
                api_post(
                    "/emails/#{email_id}/action",
                    body: {
                        spam: {
                            status: convert_status( enabled ),
                            type: type
                        }
                    },
                    error_message: "Failed to set spam filter in email account (email_id: #{email_id}, enabled: #{enabled}, type: #{type})." 
                ) do | res |
                    email_id
                end
            end

            # Sets the email forwarding copy.
            #
            # @param [String]               email_id        Email ID
            # @param [String or Boolean]    enabled         When "enable" or true, sets to leave forwarded mail in inbox
            #
            # @return [String]              When succeeded, updated email account ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-email-forwarding-copy.html
            def set_email_forwarding_copy( email_id, enabled: )
                api_post(
                    "/emails/#{email_id}/action",
                    body: {
                        forwarding_copy: {
                            status: convert_status( enabled )
                        }
                    },
                    error_message: "Failed to set forwarding copy in email account (email_id: #{email_id}, enabled: #{enabled})." 
                ) do | res |
                    email_id
                end
            end

            # Deletes the email account.
            #
            # @param [String] email_id      Email ID
            #
            # @return [String]              When succeeded, deleted email account ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-delete-domain.html
            def delete_email( email_id )
                api_delete( 
                    "/emails/#{email_id}",
                    error_message: "Failed to delete email account (email_id: #{email_id})."
                ) do | res |
                    email_id
                end
            end

            # Gets a message list.
            #
            # @param            [String]    email_id        Email ID 
            # @param            [Hash]      url_query       URL query
            # @option url_query [Integer]   :offset         (0) Offset
            # @option url_query [Integer]   :limit          (1000 Number of item
            # @option url_query [String]    :sort_key       ("date") Sort key ( It can also be specified from the constant list of {Types::Mail::SortKeyMessage}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Mail::MessageItem>]     When succeeded, message list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_email_messgae_item
            # @see https://www.conoha.jp/docs/paas-mail-list-messages.html
            def get_email_message_list( email_id, **url_query )
                uri = URI.parse( "/emails/#{email_id}/messages" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get message list (email_id: #{email_id}, url_query: #{url_query})." )
                return [] unless json_data.key?( 'messages' )

                json_data['messages'].map { | message | Types::Mail::MessageItem.new( message ) }
            end

            # Gets a message item.
            #
            # @param [String] email_id      Email ID
            # @param [String] message_id    Message ID
            #
            # @return [Nocoah::Types::Mail::MessageItemDetail]      When succeeded, message item.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_email_message_list
            # @see https://www.conoha.jp/docs/paas-mail-get-messages.html
            def get_email_message_item( email_id, message_id )
                json_data = api_get(
                    "/emails/#{email_id}/messages/#{message_id}",
                    error_message: "Failed to get message item (email_id: #{email_id}, message_id: #{message_id})."
                )
                return nil unless json_data.key?( 'message' )

                Types::Mail::MessageItemDetail.new( json_data['message'] )
            end

            # Gets a attachment file item.
            #
            # @param [String] email_id          Email ID
            # @param [String] message_id        Message ID
            # @param [String] attachment_id     Attachment ID
            #
            # @return [Nocoah::Types::Mail::AttachementItem]    When succeeded, attachment file item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-get-messages-attachments.html
            def get_email_attachment_item( email_id, message_id, attachment_id )
                json_data = api_get(
                    "/emails/#{email_id}/messages/#{message_id}/attachments/#{attachment_id}",
                    error_message: "Failed to get attachment file item (email_id: #{email_id}, message_id: #{message_id}, attachment_id: #{attachment_id})."
                )
                return nil unless json_data.key?( 'attachment' )

                Types::Mail::AttachementItem.new( json_data['attachment'] )
            end

            # Deletes the message.
            #
            # @param [String] email_id      Email ID
            # @param [String] message_id    Message ID
            #
            # @return [String]              When succeeded, deleted message ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-delete-messages.html
            def delete_email_message( email_id, message_id )
                api_delete( 
                    "/emails/#{email_id}/messages/#{message_id}",
                    error_message: "Failed to delete message (email_id: #{email_id}, message_id: #{message_id})."
                ) do | res |
                    message_id
                end
            end

            # Gets a webhook item.
            #
            # @param [String] email_id          Email ID
            #
            # @return [Nocoah::Types::Mail::WebhookItem]    When succeeded, webhook item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-list-email-filter.html
            def get_email_webhook_item( email_id )
                json_data = api_get(
                    "/emails/#{email_id}/webhook",
                    error_message: "Failed to get webhook item (email_id: #{email_id})."
                )
                return nil unless json_data.key?( 'webhook' )

                Types::Mail::WebhookItem.new( json_data['webhook'] )
            end

            # Creates a new webhook.
            #
            # @param  [String] email_id         Email ID
            # @param  [String] url              Webhook URL
            # @param  [String] keyword          Webhook keyword
            #
            # @example
            #   create_email_webhook(
            #       "(email_id)",
            #       url: "http://www.example.com/foo.php?action=doing",
            #       keyword: "keyword"
            #   )
            #
            # @return [Nocoah::Types::Mail::WebhookItem]    When succeeded, created webhook item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-email-webhook.html
            def create_email_webhook( email_id, url:, keyword: )
                json_data = api_post(
                    "/emails/#{email_id}/webhook",
                    body: {
                        webhook_url: url,
                        webhook_keyword: keyword
                    },
                    error_message: "Failed to create webhook (email_id: #{email_id}, url: #{url}, keyword: #{keyword})." 
                )
                return nil unless json_data.key?( 'webhook' )

                Types::Mail::WebhookItem.new( json_data['webhook'] )
            end

            # Updates the webhook.
            #
            # @param  [String] email_id         Email ID
            # @param  [String] url              Webhook URL
            # @param  [String] keyword          Webhook keyword
            #
            # @return [Nocoah::Types::Mail::WebhookItem]    When succeeded, updated webhook item.
            # @raise [Nocoah::APIError]                     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-filter.html
            def update_email_webhook( email_id, url:, keyword: )
                json_data = api_put(
                    "/emails/#{email_id}/webhook",
                    body: {
                        webhook_url: url,
                        webhook_keyword: keyword
                    },
                    error_message: "Failed to update webhook (email_id: #{email_id}, url: #{url}, keyword: #{keyword})." 
                )
                return nil unless json_data.key?( 'webhook' )

                Types::Mail::WebhookItem.new( json_data['webhook'] )
            end

            # Deletes the webhook.
            #
            # @param [String] email_id      Email ID
            #
            # @return [String]              When succeeded, email ID that deleted webhook.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-delete-messages.html
            def delete_email_webhook( email_id )
                api_delete( 
                    "/emails/#{email_id}/webhook",
                    error_message: "Failed to delete webhook (email_id: #{email_id})."
                ) do | res |
                    email_id
                end
            end

            # Gets a whitelisted mail address list.
            #
            # @param            [String]    email_id        Email ID 
            # @param            [Hash]      url_query       URL query
            # @option url_query [Integer]   :offset         (0) Offset
            # @option url_query [Integer]   :limit          (1000 Number of item
            # @option url_query [String]    :sort_key       ("target") Sort key
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<String>]       When succeeded, whitelisted mail address list.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-list-email-whitelist.html
            def get_email_whitelist( email_id, **url_query )
                uri = URI.parse( "/emails/#{email_id}/whitelist" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get whitelist (email_id: #{email_id}, url_query: #{url_query})." )
                return [] unless json_data.key?( 'targets' )

                json_data['targets'].map { | target | target['target'] }
            end

            # Updates a whitelisted mail address list.
            #
            # @param [String]           email_id        Email ID 
            # @param [Array<String>]    targets         Whitelisted mail addresses. ( When empty array or nil, clears the whitelist. )
            #
            # @return [Array<String>]       When succeeded, updated whitelisted mail address list.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-whitelist.html
            def update_email_whitelist( email_id, targets: )
                targets ||= []
                json_data = api_put(
                    "/emails/#{email_id}/whitelist",
                    body: {
                        targets: targets.map { | target | { target: target } }
                    },
                    error_message: "Failed to update whitelist (email_id: #{email_id}, targets: #{targets})."
                )
                return [] unless json_data.key?( 'targets' )

                json_data['targets'].map { | target | target['target'] }
            end

            # Gets a blacklisted mail address list.
            #
            # @param            [String]    email_id        Email ID 
            # @param            [Hash]      url_query       URL query
            # @option url_query [Integer]   :offset         (0) Offset
            # @option url_query [Integer]   :limit          (1000 Number of item
            # @option url_query [String]    :sort_key       ("target") Sort key
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<String>]       When succeeded, blacklisted mail address list.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-list-email-blacklist.html
            def get_email_blacklist( email_id, **url_query )
                uri = URI.parse( "/emails/#{email_id}/blacklist" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get blacklist (email_id: #{email_id}, url_query: #{url_query})." )
                return [] unless json_data.key?( 'targets' )

                json_data['targets'].map { | target | target['target'] }
            end

            # Updates a blacklisted mail address list.
            #
            # @param [String]           email_id        Email ID 
            # @param [Array<String>]    targets         blacklisted mail addresses. ( When empty array or nil, clears the blacklist. )
            #
            # @return [Array<String>]       When succeeded, updated blacklisted mail address list.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-blacklist.html
            def update_email_blacklist( email_id, targets: )
                targets ||= []
                json_data = api_put(
                    "/emails/#{email_id}/blacklist",
                    body: {
                        targets: targets.map { | target | { target: target } }
                    },
                    error_message: "Failed to update blacklist (email_id: #{email_id}, targets: #{targets})."
                )
                return [] unless json_data.key?( 'targets' )

                json_data['targets'].map { | target | target['target'] }
            end

            # Gets a forwarding list.
            #
            # @param            [String]    email_id        When not nil, Filter by Email ID 
            # @param            [Hash]      url_query       URL query
            # @option url_query [Integer]   :offset         (0) Offset
            # @option url_query [Integer]   :limit          (1000 Number of item
            # @option url_query [String]    :sort_key       ("create_date") Sort key ( It can also be specified from the constant list of {Types::Mail::SortKeyForwarding}. )
            # @option url_query [String]    :sort_type      ("asc") Sort direction ( 'asc' or 'desc' ) ( It can also be specified from the constant list of {Types::Common::SortDirection}. )
            #
            # @return [Array<Nocoah::Types::Mail::ForwardingItem>]      When succeeded, forwarding list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_email_messgae_item
            # @see https://www.conoha.jp/docs/paas-mail-list-email-forwarding.html
            def get_forwarding_list( email_id = nil, **url_query )
                uri = URI.parse( "/forwarding" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.nil?

                json_data = api_get( uri.to_s, error_message: "Failed to get forwarding list (url_query: #{url_query})." )
                return [] unless json_data.key?( 'forwarding' )

                forwarding_list = json_data['forwarding'].map { | forwarding | Types::Mail::MessageItem.new( forwarding ) }
                forwarding_list.select! { | forwarding | forwarding.email_id == email_id } if !email_id.nil?
                
                forwarding_list
            end

            # Gets a forwarding item.
            #
            # @param [String] forwarding_id     Forwarding ID
            #
            # @return [Nocoah::Types::Mail::ForwardingItem]     When succeeded, forwarding item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-get-email-forwarding.html
            def get_forwarding_item( forwarding_id )
                json_data = api_get(
                    "/forwarding/#{forwarding_id}",
                    error_message: "Failed to get forwarding item (forwarding_id: #{forwarding_id})."
                )
                return nil unless json_data.key?( 'forwarding' )

                Types::Mail::ForwardingItem.new( json_data['forwarding'] )
            end

            # Creates a new forwarding.
            #
            # @param  [String] email_id         Email ID
            # @param  [String] address          Forwarding mail address.
            #
            # @example
            #   create_forwarding(
            #       "(email_id)",
            #       address: "forward@example.com"
            #   )
            #
            # @return [Nocoah::Types::Mail::ForwardingItem]     When succeeded, created forwarding item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-create-email-forwarding.html
            def create_forwarding( email_id, address: )
                json_data = api_post(
                    "/forwarding",
                    body: {
                        address: address
                    },
                    error_message: "Failed to create forwarding (email_id: #{email_id}, address: #{address})." 
                )
                return nil unless json_data.key?( 'forwarding' )

                Types::Mail::ForwardingItem.new( json_data['forwarding'] )
            end

            # Updates the forwarding.
            #
            # @param  [String] forwarding_id    Forwarding ID
            # @param  [String] address          Forwarding mail address.
            #
            # @return [Nocoah::Types::Mail::ForwardingItem]     When succeeded, updated forwarding item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-forwarding.html
            def update_forwarding( forwarding_id, address: )
                targets ||= []
                json_data = api_put(
                    "/forwarding/#{forwarding_id}",
                    body: {
                        address: address
                    },
                    error_message: "Failed to update forwarding (forwarding_id: #{forwarding_id}, address: #{address})."
                )
                return [] unless json_data.key?( 'forwarding' )

                Types::Mail::ForwardingItem.new( json_data['forwarding'] )
            end

            # Deletes the forwarding.
            #
            # @param [String] forwarding_id     Forwarding ID
            #
            # @return [String]              When succeeded, deleted forwarding ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/paas-mail-update-email-forwarding.html
            def delete_forwarding( forwarding_id )
                api_delete( 
                    "/forwarding/#{forwarding_id}",
                    error_message: "Failed to delete forwarding (forwarding_id: #{forwarding_id})."
                ) do | res |
                    forwarding_id
                end
            end

            private

            # Converts a enabled status ( "enable" or "disable" )
            #
            # @param [String or Boolean] enabled    Status
            #
            # return [String]       "enable" : When enabled is "enable" or true / "disable" : Otherwise
            def self.convert_status( enabled )
                case enabled
                when TrueClass
                    status = "enable"
                when FalseClass
                    status = "disable"
                else
                    status = enabled == "enable" ? enabled : "disable" 
                end
                status
            end

        end

    end

end