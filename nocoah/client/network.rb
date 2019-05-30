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

            # Endpoint key
            ENDPOINT_KEY = :network

            # Gets a network list.
            #
            # @return [Array<Nocoah::Types::Network::NetworkItem>]      When succeeded, network list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_network_item
            # @see https://www.conoha.jp/docs/neutron-get_networks_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-networks-detail#list-networks
            def get_network_list        
                json_data = api_get( "/networks", error_message: "Failed to get network list." )
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
                json_data = api_get(
                    "/networks/#{network_id}",
                    error_message: "Failed to get network item (network_id: #{network_id})."
                )
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
                json_data = api_post( "/networks", error_message: "Failed to create network." )
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
                api_delete(
                    "/networks/#{network_id}",
                    error_message: "Failed to delete network (network_id: #{network_id})."
                ) do | res |
                    network_id
                end
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
                json_data = api_get( "/ports", error_message: "Failed to get port list." )
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
                json_data = api_get(
                    "/ports/#{port_id}",
                    error_message: "Failed to get port item (port_id: #{port_id})."
                )
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
                options_org = options.dup
                options[:network_id] = network_id
                json_data = api_post(
                    "/ports",
                    body: {
                        port: options
                    },
                    error_message: "Failed to create port (network_id: #{network_id}, options: #{options_org})."
                )
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
                json_data = api_post( "/ports", body: { ports: ports }, error_message: "Failed to create ports (ports: #{ports})." )
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
                json_data = api_put(
                    "/ports/#{port_id}",
                    body: {
                        port: options
                    },
                    error_message: "Failed to update port (port_id: #{port_id}, options: #{options})."
                )
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
                api_delete( "/ports/#{port_id}", error_message: "Failed to delete port (port_id: #{port_id})." ) do | res |
                    port_id
                end
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
                json_data = api_get( "/subnets", error_message: "Failed to get subnet list." )
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
                json_data = api_get( 
                    "/subnets/#{subnet_id}", 
                    error_message: "Failed to get subnet item (subnet_id: #{subnet_id})."
                )
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
            # @note ConoHa: Creates subnet for local network.
            #
            # @see https://www.conoha.jp/docs/neutron-add_subnet.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-subnet-detail#create-subnet
            def create_subnet( network_id, cidr: )
                json_data = api_post(
                    "/subnets",
                    body: {
                        subnet: {
                            network_id: network_id,
                            cidr: cidr
                        }
                    },
                    error_message: "Failed to create subnet (network_id: #{network_id}, cidr: #{cidr})."
                )
                return nil unless json_data.key?( 'subnet' )

                Types::Network::SubnetItem.new( json_data['subnet'] )
            end

            # Purchases for an additional IP address and creates a new subnet.
            #
            # @param [Integer] bitmask      Bit mask (Default: 32) (ConoHa: 28..32) ( This parameter takes precedence. )
            # @param [Integer] add_num      Number of purchase and create IPs (Default: 1) (ConoHa: 1, 2, 4, 8, 16)
            #
            # @note ConoHa: The minimum usage period for additional IP addresses is 30 days.
            #
            # @return [Nocoah::Types::Network::SubnetItem]      When succeeded, created subnet item.
            # @raise [Nocoah::ArgumentError]                    When specified or calculated ( from add_num ) bitmask is invalid.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_subnet_for_addip.html
            # @see https://support.conoha.jp/v/setipv4/
            # @see https://www.conoha.jp/vps/pricing/
            def create_subnet_for_addtional_ip( bitmask: nil, add_num: nil )
                add_num ||= 1
                bitmask ||= 32 - Math.log2( add_num ).to_i
                raise ArgumentError, "Invalid argments: bitmask: #{bitmask}, add_num: #{add_num}"
                
                json_data = api_post(
                    "/allocateips",
                    body: {
                        allocateip: {
                            bitmask: bitmask
                        }
                    },
                    error_message: "Failed to create subnet for addtional IP (bitmask: #{bitmask}, add_num: #{add_num})."
                )
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
                json_data = api_post( "/lb/subnets", error_message: "Failed to create subnet for LB." )
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
                api_delete( "/subnets/#{subnet_id}", error_message: "Failed to delete subnet (subnet_id: #{subnet_id})." ) do | res |
                    subnet_id
                end
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
                json_data = api_get( "/lb/pools", error_message: "Failed to get loadbalancer pool list." )
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
                json_data = api_get(
                    "/lb/pools/#{pool_id}",
                    error_message: "Failed to get loadbalancer pool item (pool_id: #{pool_id})."
                )
                return nil unless json_data.key?( 'pool' )

                Types::Network::PoolItem.new( json_data['pool'] )
            end

            # Creates a new loadbalancer pool and assigns to the subnet.
            #
            # @param [String]                                                   name            Pool name
            # @param [String]                                                   subnet_id       Assigned subnet ID
            # @param [String (Nocoah::Types::Network::LoadbalancerAlgorithm)]   lb_method       Loadbalancer method ( 'ROUND_ROBIN' or 'LEAST_CONNECTIONS' )
            #
            # @return [Nocoah::Types::Network::PoolItem]        When succeeded, created loadbalancer pool item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_pool.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-pool-detail#create-pool
            def create_lb_pool( name, subnet_id:, lb_method: )        
                json_data = api_post(
                    "/lb/pools",
                    body: {
                        pool: {
                            lb_method: lb_method,
                            protocol: "TCP",
                            name: name,
                            subnet_id: subnet_id
                        }
                    },
                    raise_api_failed: false
                ) do | res |
                    if res.status >= HTTP::Status::BAD_REQUEST
                        json_data = JSON.parse( res.body ) rescue {}
                        raise APIError, message: json_data['NeutronError']['message'], http_code: res.status if json_data.key?( 'NeutronError' )
                        raise APIError, message: json_data['badRequest']['message'], http_code: res.status if json_data.key?( 'badRequest' )
                        raise APIError, message: "Failed to create loadbalancer pool (name: #{name}, subnet_id: #{subnet_id}, lb_method: #{lb_method}).", http_code: res.status
                    end
                    JSON.parse( res.body )
                end
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
                json_data = api_put(
                    "/lb/pools/#{pool_id}",
                    body: {
                        pool: {
                            lb_method: lb_method,
                            name: name
                        }
                    },
                    error_message: "Failed to update loadbalancer pool (pool_id: #{pool_id}, options: #{options})."
                )
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
                api_delete(
                    "/lb/pools/#{pool_id}",
                    error_message: "Failed to delete loadbalancer pool (pool_id: #{pool_id})."
                ) do | res |
                    pool_id
                end
            end

            # Gets a loadbalancer vip list.
            #
            # @return [Array<Nocoah::Types::Network::VIPItem>]      When succeeded, loadbalancer vip list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_lb_vip_item
            # @see https://www.conoha.jp/docs/neutron-get_vips_list.html
            def get_lb_vip_list
                json_data = api_get( "/lb/vips", error_message: "Failed to get loadbalancer vip list." )
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
                json_data = api_get(
                    "/lb/vips/#{vip_id}",
                    error_message: "Failed to get loadbalancer vip item (vip_id: #{vip_id})."
                )
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
                options_org = options.dup
                options[:protocol] = "TCP"
                options[:admin_state_up] = admin_state_up
                options[:subnet_id] = subnet_id
                options[:pool_id] = pool_id
        
                json_data = api_post(
                    "/lb/pools",
                    body: {
                        pool: options
                    },
                    error_message: "Failed to create loadbalancer vip (subnet_id: #{subnet_id}, pool_id: #{pool_id}, protocol_port: #{protocol_port}, admin_state_up: #{admin_state_up}, options: #{options_org})."
                )
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
                api_delete(
                    "/lb/vips/#{vip_id}",
                    error_message: "Failed to delete loadbalancer vip (vip_id: #{vip_id})."
                ) do | res |
                    vip_id
                end
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
                json_data = api_get( "/lb/members", error_message: "Failed to get loadbalancer member list." )
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
                json_data = api_get(
                    "/lb/members/#{member_id}",
                    error_message: "Failed to get loadbalancer member item (member_id: #{member_id})."
                )
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
            # @return [Nocoah::Types::Network::MemberItem]      When succeeded, created loadbalancer member item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-add_member.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=add-member-to-pool-detail#add-member-to-pool
            def create_lb_member( pool_id, address:, protocol_port:, weight: 1 )
                json_data = api_post(
                    "/lb/members",
                    body: {
                        member: {
                            pool_id: pool_id,
                            address: address,
                            protocol_port: protocol_port,
                            weight: weight
                        }
                    },
                    error_message: "Failed to create loadbalancer member (pool_id: #{pool_id}, address: #{address}, protocol_port: #{protocol_port}, weight: #{weight})."
                )
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
            # @return [Nocoah::Types::Network::MemberItem]      When succeeded, created loadbalancer member item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-update_member.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=add-member-to-pool-detail#add-member-to-pool
            def update_lb_member( member_id, **options )
                json_data = api_put(
                    "/lb/members/#{member_id}",
                    body: {
                        member: options
                    },
                    error_message: "Failed to update loadbalancer member (member_id: #{member_id}, options: #{options})."
                )
                return nil unless json_data.key?( 'member' )

                Types::Network::MemberItem.new( json_data['member'] )
            end

            # Deletes the loadbalancer member.
            #
            # @param [String] member_id     Member ID to delete
            #
            # @return [String]              When succeeded, deleted loadbalancer member ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-remove_member.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=remove-member-from-pool-detail#remove-member-from-pool
            def delete_lb_member( member_id )
                api_delete(
                    "/lb/members/#{member_id}",
                    error_message: "Failed to delete loadbalancer member (member_id: #{member_id})."
                ) do | res |
                    member_id
                end
            end

            # Gets a loadbalancer health monitor list.
            #
            # @return [Array<Nocoah::Types::Network::HealthMonitorItem>]        When succeeded, loadbalancer health monitor list.
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see get_lb_health_monitor_item
            # @see https://www.conoha.jp/docs/neutron-get_healthmonitors_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-health-monitors-detail#list-health-monitors
            def get_lb_health_monitor_list
                json_data = api_get( "/lb/health_monitors", error_message: "Failed to get loadbalancer health monitor list." )
                return [] unless json_data.key?( 'health_monitors' )

                json_data['health_monitors'].map do | health_monitor |
                    Types::Network::HealthMonitorItem.new( health_monitor )
                end
            end

            # Gets a loadbalancer health monitor item.
            #
            # @param [String]   health_monitor_id       Health monitor ID
            #
            # @return [Nocoah::Types::Network::HealthMonitorItem]       When succeeded, loadbalancer health monitor item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_lb_health_monitor_list
            # @see https://www.conoha.jp/docs/neutron-get_healthmonitors_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-health-monitor-details-detail#show-health-monitor-details
            def get_lb_health_monitor_item( health_monitor_id )
                json_data = api_get(
                    "/lb/health_monitors/#{health_monitor_id}",
                    error_message: "Failed to get loadbalancer health monitor item (health_monitor_id: #{health_monitor_id})."
                )
                return nil unless json_data.key?( 'health_monitor' )

                Types::Network::HealthMonitorItem.new( json_data['health_monitor'] )
            end

            # Creates a new loadbalancer health monitor.
            #
            # @param          [String (Nocoah::Types::Network::HealthMonitorType)]      type                Health monitor type ( 'PING', 'TCP' or 'HTTP' )
            # @param          [Integer]                                                 delay               Health check interval (ConoHa: 5..10)
            # @param          [Hash]                                                    options             Options
            # @option options [String]                                                  :url_path           URL path
            # @option options [String]                                                  :expected_codes     Expected HTTP code
            #
            # @return [Nocoah::Types::Network::HealthMonitorItem]       When succeeded, created loadbalancer health monitor item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-create_health_monitor.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-health-monitor-detail#create-health-monitor
            def create_lb_health_monitor( type, delay: 5, **options )
                options_org = options.dup
                options[:type] = type
                options[:delay] = delay
                json_data = api_post(
                    "/lb/health_monitors",
                    body: {
                        health_monitor: options
                    },
                    error_message: "Failed to create loadbalancer health monitor (type: #{type}, delay: #{delay}, options: #{options_org})."
                )
                return nil unless json_data.key?( 'health_monitor' )

                Types::Network::HealthMonitorItem.new( json_data['health_monitor'] )
            end

            # Updates the loadbalancer health monitor.
            #
            # @param          [String]    health_monitor_id         Health monitor ID
            # @param          [Hash]      options                   Options
            # @option options [Integer]   :delay                    Health check interval (ConoHa: 5..10)
            # @option options [String]    :url_path                 URL path
            #
            # @return [Nocoah::Types::Network::HealthMonitorItem]       When succeeded, updated loadbalancer health monitor item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-change_health_monitor.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=update-health-monitor-detail#update-health-monitor
            def update_lb_health_monitor( health_monitor_id, **options )
                json_data = api_put(
                    "/lb/health_monitors/#{health_monitor_id}",
                    body: {
                        health_monitor: options
                    },
                    error_message: "Failed to update loadbalancer health monitor (health_monitor_id: #{health_monitor_id}, options: #{options})."
                )
                return nil unless json_data.key?( 'health_monitor' )

                Types::Network::HealthMonitorItem.new( json_data['health_monitor'] )
            end

            # Deletes the loadbalancer health monitor.
            #
            # @param [String] health_monitor_id         Health monitor ID to delete
            #
            # @return [String]              When succeeded, deleted loadbalancer health monitor ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-delete_health_monitor.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=remove-health-monitor-detail#remove-health-monitor
            def delete_lb_health_monitor( health_monitor_id )
                api_delete(
                    "/lb/health_monitors/#{health_monitor_id}",
                    error_message: "Failed to delete loadbalancer health monitor (health_monitor_id: #{health_monitor_id})."
                ) do | res |
                    health_monitor_id
                end
            end

            # Associates the loadbalancer health monitor to the pool.
            #
            # @param [String] pool_id               Pool ID
            # @param [String] health_monitor_id     Health monitor ID
            #
            # @return [String]              When succeeded, associated loadbalancer health monitor ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-set_health_monitor_on_pool.html
            def associate_lb_health_monitor( pool_id, health_monitor_id: )
                json_data = api_post(
                    "/lb/pools/#{pool_id}/health_monitors",
                    body: {
                        health_monitor: {
                            id: health_monitor_id
                        }
                    },
                    error_message: "Failed to associate loadbalancer health monitor to pool (pool_id: #{pool_id}, health_monitor_id: #{health_monitor_id})."
                ) do | res |
                    health_monitor_id
                end
            end

            # Disassociates the loadbalancer health monitor from the pool.
            #
            # @param [String] pool_id               Pool ID
            # @param [String] health_monitor_id     Health monitor ID
            #
            # @return [String]              When succeeded, disassociated loadbalancer health monitor ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-deallocate_health_monitor.html
            def disassociate_lb_health_monitor( pool_id, health_monitor_id: )
                json_data = api_delete(
                    "/lb/pools/#{pool_id}/health_monitors/#{health_monitor_id}",
                    error_message: "Failed to disassociate loadbalancer health monitor from pool (pool_id: #{pool_id}, health_monitor_id: #{health_monitor_id})."
                ) do | res |
                    health_monitor_id
                end
            end

            # Gets a security group list.
            #
            # @return [Array<Nocoah::Types::Network::SecurityGroupItem>]        When succeeded, security group list.
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see get_security_group_item
            # @see https://www.conoha.jp/docs/neutron-get_secgroups_list.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-security-groups-detail#list-security-groups
            def get_security_group_list
                json_data = api_get( "/security-groups", error_message: "Failed to get security group list." )
                return [] unless json_data.key?( 'security_groups' )

                json_data['security_groups'].map do | sg |
                    Types::Network::SecurityGroupItem.new( sg )
                end
            end

            # Gets a security group item.
            #
            # @param [String]   security_group_id       Security group ID
            #
            # @return [Nocoah::Types::Network::SecurityGroupItem]       When succeeded, security group item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_security_group_list
            # @see https://www.conoha.jp/docs/neutron-get_secgroups_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-security-group-detail#show-security-group
            def get_security_group_item( security_group_id )
                json_data = api_get(
                    "/security-groups/#{security_group_id}",
                    error_message: "Failed to get security group item (security_group_id: #{security_group_id})."
                )
                return nil unless json_data.key?( 'security_group' )

                Types::Network::SecurityGroupItem.new( json_data['security_group'] )
            end

            # Creates a new secrity group.
            #
            # @param [String]   name                Security group name
            # @param [String]   description         Description
            #
            # @return [Nocoah::Types::Network::SecurityGroupItem]       When succeeded, created security group item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-create_secgroup.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-security-group-detail#create-security-group
            def create_security_group( name, description: "" )
                json_data = api_post(
                    "/security-groups",
                    body: {
                        security_group: {
                            name: name,
                            description: description
                        }
                    },
                    error_message: "Failed to create security group (name: #{name}, description: #{description})."
                )
                return nil unless json_data.key?( 'security_group' )

                Types::Network::SecurityGroupItem.new( json_data['security_group'] )
            end

            # Updates the secrity group.
            #
            # @param          [String]      security_group_id           Security group ID
            # @param          [Hash]        options                     Options
            # @option options [String]      :name                       Security group name
            # @option options [String]      :description                Description
            #
            # @return [Nocoah::Types::Network::SecurityGroupItem]       When succeeded, updated security group item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-update_secgroup.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=update-security-group-detail#update-security-group
            def update_security_group( security_group_id, **options )
                json_data = api_put(
                    "/security-groups/#{security_group_id}",
                    body: {
                        security_group: options
                    },
                    error_message: "Failed to update security group (security_group_id: #{security_group_id}, options: #{options})."
                )
                return nil unless json_data.key?( 'security_group' )

                Types::Network::SecurityGroupItem.new( json_data['security_group'] )
            end

            # Deletes the secrity group.
            #
            # @param [String] security_group_id         Security group ID to delete
            #
            # @return [String]              When succeeded, deleted secrity group ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-delete_secgroup.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=delete-security-group-detail#delete-security-group
            def delete_security_group( security_group_id )
                api_delete(
                    "/security-groups/#{security_group_id}",
                    error_message: "Failed to delete secrity group (security_group_id: #{security_group_id})."
                ) do | res |
                    security_group_id
                end
            end

            # Gets a security group rule list.
            #
            # @param [String] security_group_id         Security group ID ( When nil, gets all security group rule list )
            #
            # @return [Array<Nocoah::Types::Network::SecurityGroupRule>]        When succeeded, security group rule list.
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see get_security_group_rule_item
            # @see https://www.conoha.jp/docs/neutron-get_rules_on_secgroup.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=list-security-group-rules-detail#list-security-group-rules
            def get_security_group_rule_list( security_group_id = nil )
                json_data = api_get( "/security-group-rules", error_message: "Failed to get security group rule list." )
                return [] unless json_data.key?( 'security_group_rules' )

                json_data['security_group_rules'].select! do | rule |
                    rule['security_group_id'] == security_group_id
                end if !security_group_id.nil?
                json_data['security_group_rules'].map do | rule |
                    Types::Network::SecurityGroupRule.new( rule )
                end
            end

            # Gets a security group rule item.
            #
            # @param [String]   security_group_rule_id      Security group rule ID
            #
            # @return [Nocoah::Types::Network::SecurityGroupRule]       When succeeded, security group rule item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_security_group_rule_list
            # @see https://www.conoha.jp/docs/neutron-get_rules_detail_specified.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=show-security-group-rule-detail#show-security-group-rule
            def get_security_group_rule_item( security_group_rule_id )
                json_data = api_get(
                    "/security-group-rules/#{security_group_rule_id}",
                    error_message: "Failed to get security group rule item (security_group_rule_id: #{security_group_rule_id})."
                )
                return nil unless json_data.key?( 'security_group_rule' )

                Types::Network::SecurityGroupItem.new( json_data['security_group_rule'] )
            end

            # Creates a new secrity group rule.
            #
            # @param          [String]                                                          security_group_id           Security group ID
            # @param          [String (Nocoah::Types::Network::SecurityGroupRuleDirection)]     direction                   Direction
            # @param          [String (Nocoah::Types::Network::SecurityGroupRuleEtherType)]     ethertype                   Ether type
            # @param          [Hash]                                                            options                     Options
            # @option options [Integer]                                                         :port_range_min             Minimum port range
            # @option options [Integer]                                                         :port_range_max             Maximum port range
            # @option options [String (Nocoah::Types::Network::SecurityGroupRuleProtocol)]      :protocol                   Protocol
            # @option options [String]                                                          :remote_group_id            Remote group ID
            # @option options [String]                                                          :remote_ip_prefix           
            #
            # @return [Nocoah::Types::Network::SecurityGroupRule]       When succeeded, created security group rule item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-create_rule_on_secgroup.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=create-security-group-rule-detail#create-security-group-rule
            def create_security_group_rule( security_group_id, direction:, ethertype:, **options )
                sg_rule_param = options.dup
                sg_rule_param[:security_group_id] = security_group_id
                sg_rule_param[:direction] = direction
                sg_rule_param[:ethertype] = ethertype
                json_data = api_post(
                    "/security-group-rules",
                    body: {
                        security_group_rule: sg_rule_param
                    },
                    error_message: "Failed to create security group rule (security_group_id: #{security_group_id}, direction: #{direction}, ethertype: #{ethertype}, options: #{options})."
                )
                return nil unless json_data.key?( 'security_group_rule' )

                Types::Network::SecurityGroupRule.new( json_data['security_group_rule'] )
            end

            # Deletes the secrity group rule.
            #
            # @param [String] security_group_rule_id         Security group rule ID to delete
            #
            # @return [String]              When succeeded, deleted secrity group rule ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/neutron-delete_rule_on_secgroup.html
            # @see https://developer.openstack.org/api-ref/network/v2/index.html?expanded=delete-security-group-rule-detail#delete-security-group-rule
            def delete_security_group_rule( security_group_rule_id )
                api_delete(
                    "/security-group-rules/#{security_group_rule_id}",
                    error_message: "Failed to delete secrity group rule (security_group_rule_id: #{security_group_rule_id})."
                ) do | res |
                    security_group_rule_id
                end
            end

        end

    end

end