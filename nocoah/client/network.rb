require 'httpclient'
require 'json'
require 'uri'
require_relative '../errors'
require_relative './base'
require_relative '../types/network'

# Nocoah
module Nocoah

    # Client
    module Client

        # Network API
        class Network < Base

            # Network API Endpoint ( '%s' contains a string representing the region. )
            ENDPOINT_BASE = "https://networking.%s.conoha.io/v2.0"

            # Gets a network list.
            #
            # @return [Array<Nocoah::Types::Network::NetworkItem>]      When succeeded, network list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_network_item
            # @see https://www.conoha.jp/docs/neutron-get_networks_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-networks-detail#list-networks
            def get_network_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/networks" , header: headers )
                raise APIError, message: "Failed to get network list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'networks' )

                json_data['networks'].map do | network |
                    Types::Network::NetworkItem.new( network )
                end
            end

            # Gets a network item.
            #
            # @param [String]   network_id        Network ID
            #
            # @return [Nocoah::Types::Network::NetworkItem]     When succeeded, network item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_network_list
            # @see https://www.conoha.jp/docs/neutron-get_networks_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-network-details-detail#show-network-details
            def get_network_item( network_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/networks/#{network_id}", header: headers )
                raise APIError, message: "Failed to get network item (network_id: #{network_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'network' )

                Types::Network::NetworkItem.new( json_data['network'] )
            end

            # Creates a network.
            #
            # @return [Nocoah::Types::Network::NetworkItem]     When succeeded, created network item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_network.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-network-detail#create-network
            def create_network
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/networks" , header: headers )
                raise APIError, message: "Failed to create network.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'network' )

                Types::Network::NetworkItem.new( json_data['network'] )
            end

            # Delete the network.
            #
            # @param [String]   network_id        Network ID to delete
            #
            # @return [String]              When succeeded, deleted network ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-remove_network.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=delete-network-detail#delete-network
            def delete_network( network_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/networks/#{network_id}", header: headers )
                raise APIError, message: "Failed to delete network (network_id: #{network_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                network_id
            end

            # Gets a port list.
            #
            # @return [Array<Nocoah::Types::Network::PortItem>]     When succeeded, port list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_port_item
            # @see https://www.conoha.jp/docs/neutron-get_ports_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-ports-detail#list-ports
            def get_port_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/ports" , header: headers )
                raise APIError, message: "Failed to get port list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'ports' )

                json_data['ports'].map do | port |
                    Types::Network::PortItem.new( port )
                end
            end

            # Gets a port item.
            #
            # @param [String]   port_id         Port ID
            #
            # @return [Nocoah::Types::Network::NetworkItem]     When succeeded, port item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_port_list
            # @see https://www.conoha.jp/docs/neutron-get_ports_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-port-details-detail#show-port-details
            def get_port_item( port_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/ports/#{port_id}", header: headers )
                raise APIError, message: "Failed to get port item (port_id: #{port_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'port' )

                Types::Network::PortItem.new( json_data['port'] )
            end

            # Creates a port.
            #
            # @param            [String]            network_id                  Network ID
            # @param            [Hash]              options                     Options
            # @option options   [Array<String>]     :security_groups            Security groups ( When not specified, the default security group will be set. )
            # @option options   [Array<Hash>]       :fixed_ips                  IP address ( When not specified, an IP address will be assigned automatically. )
            # @option options   [Array<Hash>]       :allowed_address_pairs      Allowed address pairs
            #
            # @return [Nocoah::Types::Network::PortItem]        When succeeded, created port item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_port.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-port-detail#create-port
            def create_port( network_id, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                options[:network_id] = network_id
                body = {
                    port: options
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/ports" , header: headers, body: body.to_json )
                raise APIError, message: "Failed to create port (network_id: #{network_id}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'port' )

                Types::Network::PortItem.new( json_data['port'] )
            end

            # Creates multiple ports.
            #
            # @param [Array<Hash>]  ports      Ports ( see ports parameter format )
            # 
            # @example ports parameter format
            #   [
            #       {
            #           network_id: "Network ID",   # ( Required )
            #           security_groups: [
            #               # Security group IDs ( When not specified, the default security group will be set. )
            #           ]
            #           fixed_ips: [    # IP address ( When not specified, an IP address will be assigned automatically. )
            #               {
            #                   ip_address: "IP address",
            #                   subnet_id: "Subnet ID"
            #               }
            #           ],
            #           allowed_address_pairs: [    # Allowed address pairs ( Optional )
            #               {
            #                   ip_address: "IP address (CIDR)"
            #               }
            #           ]
            #       }        
            #   ]
            #
            # @return [Array<Nocoah::Types::Network::PortItem>]     When succeeded, created port list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_port.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=bulk-create-ports-detail#bulk-create-ports
            def bulk_create_port( ports )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    ports: ports
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/ports" , header: headers, body: body.to_json )
                raise APIError, message: "Failed to create ports (ports: #{ports}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'ports' )

                json_data['ports'].map do | port |
                    Types::Network::PortItem.new( port )
                end
            end

            # Updates the port.
            #
            # @param            [String]            port_id                     Port ID
            # @param            [Hash]              options                     Options
            # @option options   [Array<String>]     :security_groups            Security groups
            # @option options   [Array<Hash>]       :fixed_ips                  IP address
            # @option options   [Array<Hash>]       :allowed_address_pairs      Allowed address pairs
            #
            # @note Only specified parameters are updated.
            # @note To deallocate 'Security groups', specifies an empty array for security_groups. Also, to deallocate 'Allowed address pairs', specifies an empty array for allowed_address_pairs.
            #
            # @return [Nocoah::Types::Network::PortItem]        When succeeded, updated port item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-update_port.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=update-port-detail#update-port
            def update_port( port_id, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                options[:port_id] = port_id
                body = {
                    port: options
                }

                http_client = HTTPClient.new;
                res = http_client.put( "#{@endpoint}/ports" , header: headers, body: body.to_json )
                raise APIError, message: "Failed to update port (port_id: #{port_id}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'port' )

                Types::Network::PortItem.new( json_data['port'] )
            end

            # Delete the port.
            #
            # @param [String]   port_id     Port ID to delete
            #
            # @return [String]              When succeeded, deleted port ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-remove_port.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=delete-port-detail#delete-port
            def delete_port( port_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/ports/#{port_id}", header: headers )
                raise APIError, message: "Failed to delete port (port_id: #{port_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                port_id
            end

            # Gets a subnet list.
            #
            # @return [Array<Nocoah::Types::Network::SubnetItem>]       When succeeded, subnet list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_subnet_item
            # @see https://www.conoha.jp/docs/neutron-get_subnets_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-subnets-detail#list-subnets
            def get_subnet_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/subnets" , header: headers )
                raise APIError, message: "Failed to get subnet list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'subnets' )

                json_data['subnets'].map do | subnet |
                    Types::Network::SubnetItem.new( subnet )
                end
            end

            # Gets a subnet item.
            #
            # @param [String]   subnet_id       Subnet ID
            #
            # @return [Nocoah::Types::Network::SubnetItem]      When succeeded, subnet item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_subnet_list
            # @see https://www.conoha.jp/docs/neutron-get_subnets_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-subnet-details-detail#show-subnet-details
            def get_subnet_item( subnet_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/subnets/#{subnet_id}", header: headers )
                raise APIError, message: "Failed to get subnet item (subnet_id: #{subnet_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'subnet' )

                Types::Network::SubnetItem.new( json_data['subnet'] )
            end

            # Creates a new subnet.
            #
            # @param [String] network_id        Network ID
            # @param [String] cidr              CIDR
            #
            # @return [Nocoah::Types::Network::SubnetItem]      When succeeded, created subnet item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_subnet.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-subnet-detail#create-subnet
            def create_subnet( network_id, cidr: )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    subnet: {
                        network_id: network_id,
                        cidr: cidr
                    }
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/subnets" , header: headers, body: body.to_json )
                raise APIError, message: "Failed to create subnet (network_id: #{network_id}, cidr: #{cidr}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'subnet' )

                Types::Network::SubnetItem.new( json_data['subnet'] )
            end

            # Purchases for an additional IP address and creates a new subnet.
            #
            # @param [Integer] bitmask      Bit mask (ConoHa: 28..32) ( This parameter takes precedence. )
            # @param [Integer] add_num      Number of purchase and create IPs (ConoHa: 1, 2, 4, 8, 16)
            #
            # @note ConoHa: The minimum usage period for additional IP addresses is 30 days.
            #
            # @return [Nocoah::Types::Network::SubnetItem]      When succeeded, created subnet item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_subnet_for_addip.html
            # @see https://support.conoha.jp/v/setipv4/
            # @see https://www.conoha.jp/vps/pricing/
            def create_subnet_for_addtional_ip( bitmask: nil, add_num: nil )
                bitmask ||= 32 - Math.log2( add_num ).to_i
                
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    allocateip: {
                        bitmask: bitmask
                    }
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/allocateips" , header: headers, body: body.to_json )
                raise APIError, message: "Failed to create subnet for addtional IP (bitmask: #{bitmask}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'subnet' )

                Types::Network::SubnetItem.new( json_data['subnet'] )
            end

            # Purchases for a loadbalancer and creates a new subnet.
            #
            # @return [Nocoah::Types::Network::SubnetItem]      When succeeded, created subnet item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_subnet_for_lb.html
            # @see https://support.conoha.jp/v/loadbalancer/
            # @see https://www.conoha.jp/vps/pricing/
            def create_subnet_for_lb
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/lb/subnets" , header: headers )
                raise APIError, message: "Failed to create subnet for LB.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'subnet' )

                Types::Network::SubnetItem.new( json_data['subnet'] )
            end

            # Delete the subnet.
            #
            # @param [String]   subnet_id       Subnet ID to delete
            #
            # @return [String]              When succeeded, deleted subnet ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-remove_subnet.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=delete-subnet-detail#delete-subnet
            def delete_subnet( subnet_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/subnets/#{subnet_id}", header: headers )
                raise APIError, message: "Failed to delete subnet (subnet_id: #{subnet_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                subnet_id
            end

            # Gets a loadbalancer pool list.
            #
            # @return [Array<Nocoah::Types::Network::PoolItem>]     When succeeded, loadbalancer pool list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_lb_pool_item
            # @see https://www.conoha.jp/docs/neutron-get_pools_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-pools-detail#list-pools
            def get_lb_pool_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/lb/pools" , header: headers )
                raise APIError, message: "Failed to get loadbalancer pool list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'pools' )

                json_data['pools'].map do | pool |
                    Types::Network::PoolItem.new( pool )
                end
            end

            # Gets a loadbalancer pool item.
            #
            # @param [String]   pool_id         Pool ID
            #
            # @return [Nocoah::Types::Network::PoolItem]        When succeeded, loadbalancer pool item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_lb_pool_list
            # @see https://www.conoha.jp/docs/neutron-get_pools_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-pool-details-detail#show-pool-details
            def get_lb_pool_item( pool_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/lb/pools/#{pool_id}", header: headers )
                raise APIError, message: "Failed to get loadbalancer pool item (pool_id: #{pool_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'pool' )

                Types::Network::PoolItem.new( json_data['pool'] )
            end

            # Creates a new loadbalancer pool and assigns to the subnet.
            #
            # @param [String]   name         Pool name
            # @param [String]   subnet_id    Assigned subnet ID
            # @param [String]   lb_method    Loadbalancer method ( 'ROUND_ROBIN' or 'LEAST_CONNECTIONS' )
            #
            # @return [Nocoah::Types::Network::PoolItem]        When succeeded, created loadbalancer pool item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_pool.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-pool-detail#create-pool
            def create_lb_pool( name, subnet_id:, lb_method: )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    pool: {
                        lb_method: lb_method,
                        protocol: "TCP",
                        name: name,
                        subnet_id: subnet_id
                    }
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/lb/pools", header: headers, body: body.to_json )
                if res.status >= HTTP::Status::BAD_REQUEST
                    json_data = JSON.parse( res.body ) rescue {}
                    raise APIError, message: json_data['NeutronError']['message'], http_code: res.status if json_data.key?( 'NeutronError' )
                    raise APIError, message: json_data['badRequest']['message'], http_code: res.status if json_data.key?( 'badRequest' )
                    raise APIError, message: "Failed to create loadbalancer pool (name: #{name}, subnet_id: #{subnet_id}, lb_method: #{lb_method}).", http_code: res.status
                end
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'pool' )

                Types::Network::PoolItem.new( json_data['pool'] )
            end

            # Update the loadbalancer pool.
            #
            # @param            [String]   pool_id          Pool ID
            # @param            [String]   options          Options
            # @option options   [String]   :name            Pool name
            # @option options   [String]   :lb_method       Loadbalancer method ( 'ROUND_ROBIN' or 'LEAST_CONNECTIONS' )
            #
            # @return [Nocoah::Types::Network::PoolItem]        When succeeded, updated loadbalancer pool item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-change_balancer_type.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=update-pool-detail#update-pool
            def update_lb_pool( pool_id, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    pool: {
                        lb_method: lb_method,
                        name: name
                    }
                }

                http_client = HTTPClient.new;
                res = http_client.put( "#{@endpoint}/lb/pools/#{pool_id}", header: headers, body: body.to_json )
                raise APIError, message: "Failed to update loadbalancer pool (pool_id: #{pool_id}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'pool' )

                Types::Network::PoolItem.new( json_data['pool'] )
            end

            # Delete the loadbalancer pool.
            #
            # @param [String]   pool_id     Pool ID to delete
            #
            # @return [String]              When succeeded, deleted pool ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-delete_pool.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=remove-pool-detail#remove-pool
            def delete_lb_pool( pool_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/lb/pools/#{pool_id}", header: headers )
                raise APIError, message: "Failed to delete loadbalancer pool (pool_id: #{pool_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                subnet_id
            end

            # Gets a loadbalancer vip list.
            #
            # @return [Array<Nocoah::Types::Network::VIPItem>]      When succeeded, loadbalancer vip list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_lb_vip_item
            # @see https://www.conoha.jp/docs/neutron-get_vips_list.html
            def get_lb_vip_list
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/lb/vips" , header: headers )
                raise APIError, message: "Failed to get loadbalancer vip list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'vips' )

                json_data['vips'].map do | vip |
                    Types::Network::VIPItem.new( vip )
                end
            end

            # Gets a loadbalancer vip item.
            #
            # @param [String]   vip_id          VIP ID
            #
            # @return [Nocoah::Types::Network::VIPItem]         When succeeded, loadbalancer vip item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_lb_vip_list
            # @see https://www.conoha.jp/docs/neutron-get_vips_detail_specified.html
            def get_lb_vip_item( vip_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/lb/vips/#{vip_id}", header: headers )
                raise APIError, message: "Failed to get loadbalancer vip item (vip_id: #{vip_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'vip' )

                Types::Network::VIPItem.new( json_data['vip'] )
            end

            # Creates a new loadbalancer vip and assigns to the pool.
            #
            # @param            [String]    pool_id                 Assigned port ID
            # @param            [String]    subnet_id               Subnet ID for loadbalancer
            # @param            [Integer]   protocol_port           Port number ( 0..65535 )
            # @param            [Boolean]   admin_state_up          Administrative state
            # @param            [Hash]      options                 Options
            # @option options   [String]    :name                   VIP name
            # @option options   [String]    :address                VIP IP address
            # @option options   [String]    :description            Description
            # @option options   [Integer]   :connection_limit       (-1 (unlimited)) Maximum number of simultaneous connections
            #
            # @return [Nocoah::Types::Network::VipItem]         When succeeded, created loadbalancer pool item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-create_vip.html
            def create_lb_vip( pool_id, subnet_id:, protocol_port:, admin_state_up: true, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                options[:protocol] = "TCP"
                options[:admin_state_up] = admin_state_up
                options[:subnet_id] = subnet_id
                options[:pool_id] = pool_id
                body = {
                    pool: options
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/lb/pools", header: headers, body: body.to_json )
                raise APIError, message: "Failed to create loadbalancer vip (subnet_id: #{subnet_id}, pool_id: #{pool_id}, protocol_port: #{protocol_port}, admin_state_up: #{admin_state_up}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'vip' )

                Types::Network::VIPItem.new( json_data['vip'] )
            end

            # Delete the loadbalancer vip.
            #
            # @param [String]   vip_id      VIP ID to delete
            #
            # @return [String]              When succeeded, deleted vip ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-remove_vip.html
            def delete_lb_vip( vip_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.delete( "#{@endpoint}/lb/vips/#{vip_id}", header: headers )
                raise APIError, message: "Failed to delete loadbalancer vip (vip_id: #{vip_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                subnet_id
            end

            # Gets a loadbalancer member list.
            #
            # @param [String] pool_id       Pool ID ( When nil, gets all loadbalancer members. )
            #
            # @return [Array<Nocoah::Types::Network::MemberItem>]       When succeeded, loadbalancer member list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_lb_member_item
            # @see https://www.conoha.jp/docs/neutron-get_members_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-pool-members-detail#list-pool-members
            def get_lb_member_list( pool_id = nil )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/lb/members" , header: headers )
                raise APIError, message: "Failed to get loadbalancer member list.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return [] unless json_data.key?( 'members' )

                json_data['members'].select! do | member |
                    member['port_id'] == pool_id
                end if !pool_id.nil?
                json_data['members'].map do | member |
                    Types::Network::MemberItem.new( member )
                end
            end

            # Gets a loadbalancer member item.
            #
            # @param [String]   member_id       Member ID
            #
            # @return [Nocoah::Types::Network::MemberItem]      When succeeded, loadbalancer member item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_lb_member_list
            # @see https://www.conoha.jp/docs/neutron-get_members_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-pool-member-details-detail#show-pool-member-details
            def get_lb_member_item( member_id )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.get( "#{@endpoint}/lb/members/#{member_id}", header: headers )
                raise APIError, message: "Failed to get loadbalancer member item (member_id: #{member_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'member' )

                Types::Network::MemberItem.new( json_data['member'] )
            end

            # Creates a new loadbalancer member and assigns to the pool.
            #
            # @param [String]    pool_id                Assigned port ID
            # @param [String]    address                IP address
            # @param [Integer]   protocol_port          Port number ( 0..65535 )
            # @param [Integer]   weight                 Weight ( 0..256 ) ( When 0, disabled balancing. )
            #
            # @return [Nocoah::Types::Network::VipItem]         When succeeded, created loadbalancer member item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_member.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=add-member-to-pool-detail#add-member-to-pool
            def create_lb_member( pool_id, address:, protocol_port:, weight: 1 )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    member: {
                        pool_id: pool_id,
                        address: address,
                        protocol_port: protocol_port,
                        weight: weight
                    }
                }

                http_client = HTTPClient.new;
                res = http_client.post( "#{@endpoint}/lb/members", header: headers, body: body.to_json )
                raise APIError, message: "Failed to create loadbalancer member (pool_id: #{pool_id}, address: #{address}, protocol_port: #{protocol_port}, weight: #{weight}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'member' )

                Types::Network::MemberItem.new( json_data['member'] )
            end

            # Updates the loadbalancer member.
            #
            # @param            [String]    member_id       Member ID
            # @param            [String]    options         Options
            # @option options   [Integer]   :weight         Weight ( 0..256 ) ( When 0, disabled balancing. )
            # @option options   [String]    :pool_id        Port ID ( When changing pool of the connection destination )
            #
            # @return [Nocoah::Types::Network::VipItem]         When succeeded, created loadbalancer member item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-update_member.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=add-member-to-pool-detail#add-member-to-pool
            def update_lb_member( member_id, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }
                body = {
                    member: options
                }

                http_client = HTTPClient.new;
                res = http_client.put( "#{@endpoint}/lb/members/#{member_id}", header: headers, body: body.to_json )
                raise APIError, message: "Failed to update loadbalancer member (member_id: #{member_id}, options: #{options}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
                return nil unless json_data.key?( 'member' )

                Types::Network::MemberItem.new( json_data['member'] )
            end

            # Deletes the loadbalancer member.
            #
            # @param [String] member_id     Member ID to delete
            #
            # @return [String]              When succeeded, deleted loadbalancer member item.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-remove_member.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=add-member-to-pool-detail#add-member-to-pool
            def delete_lb_member( member_id, **options )
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token
                }

                http_client = HTTPClient.new;
                res = http_client.put( "#{@endpoint}/lb/members/#{member_id}", header: headers )
                raise APIError, message: "Failed to delete loadbalancer member (member_id: #{member_id}).", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                member_id
            end

        end

    end

end