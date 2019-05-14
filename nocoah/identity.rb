require 'httpclient'
require 'json'
require 'date'
require_relative './config'
require_relative './errors'

# Nocoah
module Nocoah

    # Manages ConoHa API tokens.
    class Identity

        # Identity API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
        ENDPOINT_BASE = "https://identity.%s.conoha.io/v2.0"

        # @return [Nocoah::Config] Config instance
        attr_reader :config
        # @return [String] Identity API endpoint
        attr_reader :endpoint
        # @return [String] API token
        attr_reader :api_token

        # Gets Identity API version info.
        #
        # @param [String] region    Region string.
        #
        # @return [Hash]                When succeeded, API verion info.
        # @raise [Nocoah::APIError]     When failed.
        #
        # @see https://www.conoha.jp/docs/identity-get_version_detail.html
        def self.version( region )
            headers = {
                Accept: "application/json",
            }
            http_client = HTTPClient.new;
            res = http_client.get( "#{sprintf( ENDPOINT_BASE, region )}", header: headers )

            raise APIError, message: "Failed to get version info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST

            json_data = JSON.parse( res.body )
        end

        # Initializes a new Config instance.
        #
        # @param          [Hash]            options             Options
        # @option options [Nocoah::Config]  config              The Nocoah::Config instance.
        # @option options [String]          config_file_path    The JSON file path that describes the credential configuration information of ConoHa API account
        # @option options [Hash]            api_account         The hash object that stores ConoHa API user, password, tenant ID, and region.
        #
        # @note
        #   Priority:
        #     1. :config ( when specified )
        #     2. :config_file_path ( when specified )
        #     3. :api_account ( when specified )
        #     4. Environment variables ( 'NOCOAH_...' )
        #     5. Environment variables ( 'CONOHA_...' )
        #     6. Loads from '~/.nocoah/config'
        #     7. Loads from '~/.conoha/config'
        # 
        # @see Nocoah::Config
        def initialize( **options )
            if options.key?( :config ) && options[:config].instance_of?( Nocoah::Config )
                @config = options[:config]
            else
                @config = Nocoah::Config.new( options )
            end

            @endpoint = sprintf( ENDPOINT_BASE, @config.region )

            get_token
        end

        # Gets Identity API version info.
        #
        # @return [Hash]                When succeeded, API verion info.
        # @raise [Nocoah::APIError]     When failed.
        def version
            Identity.version( @config.region )
        end

        # Gets ConoHa API token.
        #
        # @raise [Nocoah::APIError]     When failed.
        #
        # @see https://www.conoha.jp/docs/identity-post_tokens.html
        def get_token
            headers = {
                Accept: "application/json",
            }
            body = {
                auth: {
                    passwordCredentials: {
                        username: @config.api_user,
                        password: @config.api_pass,
                    },
                    tenantId: @config.tenant_id,
                }
            }
            http_client = HTTPClient.new;
            res = http_client.post( "#{@endpoint}/tokens", header: headers, body: body.to_json )
            raise APIError, message: "Failed to get Access Token.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST

            json_data = JSON.parse( res.body )

            @api_token = json_data['access']['token']['id']
            @api_token_expire_date = DateTime.parse( json_data['access']['token']['expires'] )
        end

        # Gets whether API token is available.
        #
        # @return [true]    Available
        # @return [false]   Expired
        def token_available?
            DateTime.now <= @api_token_expire_date
        end
    end

end