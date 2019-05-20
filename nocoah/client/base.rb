require_relative '../errors'
require_relative '../config'
require_relative '../identity'

# Nocoah
module Nocoah

    # Client
    module Client

        # Base
        class Base

            # API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            ENDPOINT_BASE = "https://identity.%s.conoha.io/v2.0"

            ## HTTP Client
            @@http_client = HTTPClient.new;

            # Initializes a new Base instance.
            #
            # @param          [Hash]                options             Options
            # @option options [ConoHa::Identity]    :identity           The ConoHa::Identity instance.
            # @option options [ConoHa::Config]      :config             The ConoHa::Config instance.
            # @option options [String]              :config_file_path   The JSON file path that describes the credential configuration information of ConoHa API account
            # @option options [Hash]                :api_account        The hash object that stores ConoHa API user, password, tenant ID, and region.
            #
            # @note
            #   Priority:
            #     1. :identity ( when specified )
            #     2. :config ( when specified )
            #     3. :config_file_path ( when specified )
            #     4. :api_account ( when specified )
            #     5. Environment variables ( 'NOCOAH_...' )
            #     6. Environment variables ( 'CONOHA_...' )
            #     7. Loads from '~/.nocoah/config'
            #     8. Loads from '~/.conoha/config'
            # 
            # @see Nocoah::Config
            def initialize( **options )
                if options.key?( :identity ) && options[:identity].instance_of?( Nocoah::Identity )
                    @identity = options[:identity]
                else
                    @identity = Nocoah::Identity.new( options )
                end
                
                @endpoint = sprintf( self.class::ENDPOINT_BASE, @identity.config.region )
            end

            # Get a API version info.
            #
            # @return [Hash]                When succeeded, API version info.
            # @raise [Nocoah::APIError]     When failed.
            def version
                api_get( "", error_message: "Failed to get version info." )
            end

            private

            # Calls API with GET method
            #
            # @param [String]   api_path            API url path ( from endpoint )
            # @param [Hash]     opt_header          Optional request header
            # @param [String]   error_message       Error message when api failed
            # @param [Boolean]  raise_api_failed    If true, raises {Nocoah::APIError} when api failed
            # @param [Proc]     api_res_callback    Callback ( HTTP::Message ) => Object
            #
            # @return [Hash]                When not specified api_res_callback, returns hash obuject from response body.
            # @return [Object]              When specified api_res_callback, returns the callback's return value.
            # @raise [Nocoah::APIError]     When api failed.
            def api_get( api_path, opt_header: {}, error_message: nil, raise_api_failed: true, &api_res_callback )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }.merge!( opt_header )
                error_message ||= "API GET Failed."

                res = @@http_client.get( "#{@endpoint}#{api_path}", header: headers )
                raise APIError, message: error_message, http_code: res.status if raise_api_failed && res.status >= HTTP::Status::BAD_REQUEST
                if block_given?
                    return api_res_callback.call( res )
                else
                    return JSON.parse( res.body )
                end
            end

            # Calls API with POST method
            #
            # @param [String]   api_path            API url path ( from endpoint )
            # @param [Hash]     opt_header          Optional request header
            # @param [Hash]     body                Request body
            # @param [String]   error_message       Error message when api failed
            # @param [Boolean]  raise_api_failed    If true, raises {Nocoah::APIError} when api failed
            # @param [Proc]     api_res_callback    Callback ( HTTP::Message ) => Object
            #
            # @return [Hash]                When not specified api_res_callback, returns hash obuject from response body.
            # @return [Object]              When specified api_res_callback, returns the callback's return value.
            # @raise [Nocoah::APIError]     When api failed.
            def api_post( api_path, opt_header: {}, body: {}, error_message: nil, raise_api_failed: true, &api_res_callback )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }.merge!( opt_header )
                error_message ||= "API POST Failed."

                res = @@http_client.post( "#{@endpoint}#{api_path}", header: headers, body: body.to_json )
                raise APIError, message: error_message, http_code: res.status if raise_api_failed && res.status >= HTTP::Status::BAD_REQUEST
                if block_given?
                    return api_res_callback.call( res )
                else
                    return JSON.parse( res.body )
                end
            end

            # Calls API with PUT method
            #
            # @param [String]   api_path            API url path ( from endpoint )
            # @param [Hash]     opt_header          Optional request header
            # @param [Hash]     body                Request body
            # @param [String]   error_message       Error message when api failed
            # @param [Boolean]  raise_api_failed    If true, raises {Nocoah::APIError} when api failed
            # @param [Proc]     api_res_callback    Callback ( HTTP::Message ) => Object
            #
            # @return [Hash]                When not specified api_res_callback, returns hash obuject from response body.
            # @return [Object]              When specified api_res_callback, returns the callback's return value.
            # @raise [Nocoah::APIError]     When api failed.
            def api_put( api_path, opt_header: {}, body: {}, error_message: nil, raise_api_failed: true, &api_res_callback )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }.merge!( opt_header )
                error_message ||= "API PUT Failed."

                res = @@http_client.put( "#{@endpoint}#{api_path}", header: headers, body: body.to_json )
                raise APIError, message: error_message, http_code: res.status if raise_api_failed && res.status >= HTTP::Status::BAD_REQUEST
                if block_given?
                    return api_res_callback.call( res )
                else
                    return JSON.parse( res.body )
                end
            end

            # Calls API with DELETE method
            #
            # @param [String]   api_path            API url path ( from endpoint )
            # @param [Hash]     opt_header          Optional request header
            # @param [String]   error_message       Error message when api failed
            # @param [Boolean]  raise_api_failed    If true, raises {Nocoah::APIError} when api failed
            # @param [Proc]     api_res_callback    Callback ( HTTP::Message ) => Object
            #
            # @return [Hash]                When not specified api_res_callback, returns hash obuject from response body.
            # @return [Object]              When specified api_res_callback, returns the callback's return value.
            # @raise [Nocoah::APIError]     When api failed.
            def api_delete( api_path, opt_header: {}, error_message: nil, raise_api_failed: true, &api_res_callback )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }.merge!( opt_header )
                error_message ||= "API DELETE Failed."

                res = @@http_client.delete( "#{@endpoint}#{api_path}", header: headers )
                raise APIError, message: error_message, http_code: res.status if raise_api_failed && res.status >= HTTP::Status::BAD_REQUEST
                if block_given?
                    return api_res_callback.call( res )
                else
                    return JSON.parse( res.body )
                end
            end

        end

    end

end