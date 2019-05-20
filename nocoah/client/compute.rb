require 'httpclient'
require 'json'
require 'uri'
require 'base64'
require_relative '../errors'
require_relative './base'
require_relative '../types/compute'

# Nocoah
module Nocoah

    # Client
    module Client

        # Compute API
        class Compute < Base

            # Compute API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            ENDPOINT_BASE = "https://compute.%s.conoha.io/v2"

            # Gets a virtual machine template ( flavor ) list.
            #
            # @param            [Hash]      url_query    Options
            # @option url_query [Integer]   min_disk     Filter by minimum disk size (GB)
            # @option url_query [Integer]   min_ram      Filter by minimum ram size (GB)
            # @option url_query [Integer]   limit        The number of item
            #
            # @return [Array<Nocoah::Types::Compute::FlavorItem>]   When succeeded, virtual machine template list.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_flavor_detail_list
            # @see get_flavor_detail
            # @see https://www.conoha.jp/docs/compute-get_flavors_list.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-flavors-detail#list-flavors
            def get_flavor_list( **url_query )
                json_data = get_flavor_list_core( false, url_query )
                return [] unless json_data.key?( 'flavors' )

                json_data['flavors'].map() do | flavor |
                    Types::Compute::FlavorItem.new( flavor )
                end
            end

            # Gets a virtual machine template ( flavor ) detail list.
            #
            # @param            [Hash]      url_query   Options
            # @option url_query [Integer]   min_disk    Filter by minimum disk size (GB)
            # @option url_query [Integer]   min_ram     Filter by minimum ram size (GB)
            # @option url_query [Integer]   limit       The number of item
            #
            # @return [Array<Nocoah::Types::Compute::FlavorItemDetail>]     When succeeded, flavor detail list.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_flavor_list
            # @see get_flavor_detail
            # @see https://www.conoha.jp/docs/compute-get_flavors_detail.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-flavors-with-details-detail#list-flavors-with-details
            def get_flavor_detail_list( **url_query )
                json_data = get_flavor_list_core( true, url_query )
                return [] unless json_data.key?( 'flavors' )

                json_data['flavors'].map() do | flavor |
                    Types::Compute::FlavorItemDetail.new( flavor )
                end
            end

            # Gets a virtual machine template ( flavor ) detail item.
            #
            # @param [String] flavor_id     Flavor ID
            #
            # @return [Nocoah::Types::Compute::FlavorItemDetail]    When succeeded, flavor detail item.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_flavor_list
            # @see get_flavor_detail_list
            # @see https://www.conoha.jp/docs/compute-get_flavors_detail_specified.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-flavor-details-detail#show-flavor-details
            def get_flavor_detail( flavor_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/flavors/#{flavor_id}",
                    error_message: "Failed to get flavor item detail (flavor_id: #{flavor_id})."
                )
                return nil unless json_data.key?( 'flavor' )

                Types::Compute::FlavorItemDetail.new( json_data['flavor'] )
            end

            # Gets a virtual machine list.
            #
            # @param            [Hash]      url_query       Options
            # @option url_query [DateTime]  changes-since   Virtual machine list ( including deleted ) from specified time
            # @option url_query [String]    image           Image ID
            # @option url_query [String]    flavor          Flavor ID
            # @option url_query [String]    name            Virtual machine name
            # @option url_query [String]    marker          Last-seen virtual machine ID
            # @option url_query [String]    limit           Number of item
            # @option url_query [String]    status          Virtual machine status
            #
            # @return [Array<Nocoah::Types::Compute::ServerItem>]   When succeeded, virtual machine list.
            # @raise [Nocoah::APIError]                             When failed.
            # @raise [ArgmentError]                                 When specified 'changes-since' is invalid type.
            #
            # @see get_server_detail_list
            # @see get_server_detail
            # @see https://www.conoha.jp/docs/compute-get_vms_list.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-servers-detail#list-servers
            def get_server_list( **url_query )
                json_data = get_server_list_core( false, url_query )

                return [] unless json_data.key?( 'servers' )

                json_data['servers'].map() do | server |
                    Types::Compute::ServerItem.new( server )
                end
            end

            # Gets a virtual machine detail list.
            #
            # @param            [Hash]      url_query       Options
            # @option url_query [DateTime]  changes-since   Virtual machine list ( including deleted ) from specified time
            # @option url_query [String]    image           Image ID
            # @option url_query [String]    flavor          Flavor ID
            # @option url_query [String]    name            Virtual machine name
            # @option url_query [String]    marker          Last-seen virtual machine ID
            # @option url_query [String]    limit           Number of item
            # @option url_query [String]    status          Virtual machine status
            #
            # @return [Array<Nocoah::Types::Compute::ServerDetailItem>]     When succeeded, virtual machine detail list.
            # @raise [Nocoah::APIError]                                     When failed.
            # @raise [ArgmentError]                                         When specified 'changes-since' is invalid type.
            #
            # @see get_server_list
            # @see get_server_detail
            # @see https://www.conoha.jp/docs/compute-get_vms_detail.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-servers-detailed-detail#list-servers-detailed
            def get_server_detail_list( **url_query )
                json_data = get_server_list_core( true, url_query )

                return [] unless json_data.key?( 'servers' )

                json_data['servers'].map() do | server |
                    Types::Compute::ServerItemDetail.new( server )
                end
            end

            # Gets a virtual machine detail item.
            #
            # @param [String] server_id     Server ID
            #
            # @return [Nocoah::Types::Compute::ServerDetailItem]    When succeeded, server detail item.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_server_list
            # @see get_server_detail_list
            # @see https://www.conoha.jp/docs/compute-get_vms_detail_specified.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-server-details-detail#show-server-details
            def get_server_detail( server_id )        
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}",
                    error_message: "Failed to get server item detail (server_id: #{server_id})."
                )
                return nil unless json_data.key?( 'server' )

                Types::Compute::ServerItemDetail.new( json_data['server'] )
            end

            # Gets a image list.
            #
            # @param            [Hash]      url_query       Options
            # @option url_query [DateTime]  changes-since   Image list ( including deleted ) from specified time
            # @option url_query [String]    name            Image name
            # @option url_query [String]    status          Image status
            # @option url_query [String]    marker          Last-seen image ID
            # @option url_query [String]    limit           Number of item
            # @option url_query [String]    type            Image type
            #
            # @return [Array<Nocoah::Types::Compute::ImageItem>]    When succeeded, Image list.
            # @raise [Nocoah::APIError]                             When failed.
            # @raise [ArgmentError]                                 When specified 'changes-since' is invalid type.
            #
            # @see get_image_detail_list
            # @see get_image_detail
            # @see https://www.conoha.jp/docs/compute-get_images_list.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-images-detail#list-images
            def get_image_list( **url_query )
                json_data = get_image_list_core( false, url_query )

                return [] unless json_data.key?( 'images' )

                json_data['images'].map() do | image |
                    Types::Compute::ImageItem.new( image )
                end
            end

            # Gets a image detail list.
            #
            # @param            [Hash]      url_query       Options
            # @option url_query [DateTime]  changes-since   Image list ( including deleted ) from specified time
            # @option url_query [String]    name            Image name
            # @option url_query [String]    status          Image status
            # @option url_query [String]    marker          Last-seen image ID
            # @option url_query [String]    limit           Number of item
            # @option url_query [String]    type            Image type
            #
            # @return [Array<Nocoah::Types::Compute::ImageDetailItem>]  When succeeded, Image detail list.
            # @raise [Nocoah::APIError]                                 When failed.
            # @raise [ArgmentError]                                     When specified 'changes-since' is invalid type.
            #
            # @see get_image_list
            # @see get_image_detail
            # @see https://www.conoha.jp/docs/compute-get_images_detail.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-images-with-details-detail#list-images-with-details
            def get_image_detail_list( **url_query )
                json_data = get_image_list_core( true, url_query )

                return [] unless json_data.key?( 'images' )

                json_data['images'].map() do | image |
                    Types::Compute::ImageItemDetail.new( image )
                end
            end

            # Gets a image detail item.
            #
            # @param [String] image_id      Image ID
            #
            # @return [Nocoah::Types::Compute::ImageItemDetail]     When succeeded, image detail item.
            # @raise [Nocoah::APIError]                             When failed.
            #
            # @see get_image_list
            # @see get_image_detail_list
            # @see https://www.conoha.jp/docs/compute-get_images_detail_specified.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-image-details-detail#show-image-details
            def get_image_detail( image_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/images/#{image_id}",
                    error_message: "Failed to get image item detail (image_id: #{image_id})."
                )
                return nil unless json_data.key?( 'image' )

                Types::Compute::ImageItemDetail.new( json_data['image'] )
            end

            # Creates a new virtual machine
            #
            # @param            [String]            image_id                    Image ID
            # @param            [String]            flavor_id                   Flavor ID
            # @param            [Hash]              options                     Optional settings
            # @option options   [String]            adminPass                   (nil) Root password
            # @option options   [String]            key_name                    (nil) SSH key name ( when using SSH key authentication )
            # @option options   [Array<String>]     security_groups             (nil) Security groups names
            # @option options   [String]            instance_name_tag           (nil) Virtual machine name tag
            # @option options   [String]            volume_id                   (nil) Addtional disk ID ( when using an additional disk )
            # @option options   [String]            vncKeymap                   (nil) Key map ( 'en-us' or 'ja' )
            # @option options   [String]            startup_script              (nil) Startup script
            # @option options   [String]            startup_script_path         (nil) Startup script file path 
            # @option options   [Boolean]           encode_startup_script       (false) When true, encode the startup script specified in the argument into Base64 format.
            #
            # @return [Nocoah::Types::Compute::CreateServerResult]      When succeeded, created virtual machine item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @note If both startup_script and startup_script_path are specified, only startup_script is used.
            # @note Startup script can be specified up to 16KiB without being encoded.
            # @note The headers that can be used in the startup script are '#!', '#include-once', '#include', '#cloud-config' or '#cloud-boothook'.
            # @note Startup scripts are not supported on Windows OS.
            #
            # @see https://www.conoha.jp/docs/compute-create_vm.html
            # @see https://support.conoha.jp/v/startupscript/
            # @see https://www.conoha.jp/vps/pricing/
            # @see https://developer.openstack.org/api-ref/compute/?expanded=create-server-detail#create-server
            def create_server( image_id:, flavor_id:, **options )
                server_options = {
                    imageRef: image_id,
                    flavorRef: flavor_id
                }
                server_options[:adminPass] = options[:adminPass] if options.key?( :adminPass )
                server_options[:key_name] = options[:key_name] if options.key?( :key_name )
                server_options[:vncKeymap] = options[:vncKeymap] if options.key?( :vncKeymap )

                # Security group
                if options.key?( :security_groups ) && !options[:security_groups].empty?
                    server_options[:security_groups] = options[:security_groups].map do | sg |
                        { name: sg }
                    end
                end

                # Metadata
                if options.key?( :instance_name_tag )
                    server_options[:metadata] = {
                        instance_name_tag: options[:instance_name_tag]
                    }
                end

                # Additional disk
                if options.key?( :volume_id )
                    server_options[:block_device_mapping] = [{
                        volume_id: options[:volume_id]
                    }]
                end

                # Startup script
                if options.key?( :startup_script )
                    server_options[:user_data] = Types::Common.to_b( options['encode_startup_script'] ) ? Base64.encode64( options[:startup_script] ) : options[:startup_script]
                elsif options.key?( :startup_script_path ) && File.exist?( options[:startup_script_path] )
                    server_options[:user_data] = Types::Common.to_b( options['encode_startup_script'] ) ? Base64.encode64( File.read( options[:startup_script_path] ) ) : File.read( options[:startup_script_path] )
                end

                json_data = api_post(
                    "/#{@identity.config.tenant_id}/servers",
                    body: {
                        server: server_options
                    },
                    error_message: "Failed to create server (image_id: #{image_id}, flavor_id: #{flavor_id}, options: #{options})."
                )
                return nil unless json_data.key?( 'server' )

                Types::Compute::CreateServerResult.new( json_data['server'] )
            end

            # Deletes the virtual machine.
            #
            # @param [String]   server_id   Server ID               
            #
            # @return [String]              When succeeded, Deleted virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note ConoHa: (IMPORTANT) Please note that even if Delete-Lock is enabled in the control panel, it will be deleted.
            # 
            # @see https://www.conoha.jp/docs/compute-delete_vm.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=delete-server-detail#delete-server
            def delete_server( server_id )
                api_delete(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}",
                    error_message: "Failed to delete virtual machine (server_id: #{server_id})."
                ) do | res |
                    server_id
                end
            end

            # Launches the virtual machine
            #
            # @param [String]   server_id   Server ID               
            #
            # @return [String]              When succeeded, launched virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            # 
            # @see https://www.conoha.jp/docs/compute-power_on_vm.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=delete-server-detail#delete-server
            def launch_server( server_id )
                server_action_core( server_id, "launch" )
            end

            # Restarts the virtual machine
            #
            # @param [String]   server_id   Server ID               
            #
            # @return [String]              When succeeded, restarted virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            # 
            # @see https://www.conoha.jp/docs/compute-reboot_vm.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=reboot-server-reboot-action-detail#reboot-server-reboot-action
            def restart_server( server_id )
                server_action_core( server_id, "restart" )
            end

            # Stops the virtual machine
            #
            # @param [String]   server_id   Server ID
            # @param [Boolean]  is_force    Whether to force stop       
            #
            # @return [String]              When succeeded, stopped virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            # 
            # @see https://www.conoha.jp/docs/compute-stop_forcibly_vm.html
            # @see https://www.conoha.jp/docs/compute-stop_cleanly_vm.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=stop-server-os-stop-action-detail#stop-server-os-stop-action
            def stop_server( server_id, is_force = false )
                server_action_core( server_id, is_force ? "force-stop" : "stop" )
            end

            # Rebuilds the virtual machine.
            #
            # @param            [String]    server_id   Server ID
            # @param            [String]    image_id    Image ID
            # @param            [Hash]      options     Optional settings
            # @option options   [String]    adminPass   Root password
            # @option options   [String]    key_name    SSH key name ( when using SSH key authentication )               
            #
            # @return [Nocoah::Types::Compute::RebuildServerResult]     When succeeded, rebuilt virtual machine item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/compute-re_install.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=rebuild-server-rebuild-action-detail#rebuild-server-rebuild-action
            def rebuild_server( server_id, image_id:, **options )
                rebuild_options = {
                    imageRef: image_id
                }
                rebuild_options[:adminPass] = options[:adminPass] if options.key?( :adminPass )
                rebuild_options[:key_name] = options[:key_name] if options.key?( :key_name )
                        
                json_data = api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: {
                        rebuild: rebuild_options
                    },
                    error_message: "Failed to rebuild virtual machine (server_id: #{server_id}, image_id: #{image_id}, options: #{options})."
                )
                return nil unless json_data.key?( 'server' )

                Types::Compute::RebuildServerResult.new( json_data['server'] )
            end

            # Resizes the virtual machine
            #
            # @param [String]    server_id   Server ID
            # @param [String]    flavor_id   Flavor ID          
            #
            # @return [String]              When succeeded, resized virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note When this process is successful, the virtual machine status will be "RESIZE", "VERIFY_RESIZE". 
            #       To complete resizing, call {confirm_resize_server}, and to restore, call {revert_resize_server}.
            #
            # @see confirm_resize_server
            # @see revert_resize_server
            # @see https://www.conoha.jp/docs/compute-vm_resize.html
            # @see https://www.conoha.jp/vps/pricing/
            # @see https://developer.openstack.org/api-ref/compute/?expanded=resize-server-resize-action-detail#resize-server-resize-action
            def resize_server( server_id, flavor_id: )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: {
                        resize: {
                            flavorRef: flavor_id
                        }
                    },
                    error_message: "Failed to resize virtual machine (server_id: #{server_id}, flavor_id: #{flavor_id}, options: #{options})."
                ) do | res |
                    server_id
                end
            end

            # Confirms resize the virtual machine
            #
            # @param [String]    server_id   Server ID
            #
            # @return [String]              When succeeded, resized virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note When this process is successful, the virtual machine status will be "ACTIVE", "SHUTOFF". 
            #
            # @see resize_server
            # @see revert_resize_server
            # @see https://www.conoha.jp/docs/compute-vm_resize_confirm.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=confirm-resized-server-confirmresize-action-detail#confirm-resized-server-confirmresize-action
            def confirm_resize_server( server_id )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action", 
                    body: {
                        confirmResize: nil
                    },
                    error_message: "Failed to confirm resize virtual machine (server_id: #{server_id}, options: #{options})."
                ) do | res |
                    server_id
                end
            end

            # Reverts resize the virtual machine
            #
            # @param [String]    server_id   Server ID
            #
            # @return [String]              When succeeded, reverted virtual machine server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note When this process is successful, the virtual machine status will be "ACTIVE", "SHUTOFF". 
            #
            # @see resize_server
            # @see confirm_resize_server
            # @see https://www.conoha.jp/docs/compute-vm_resize_revert.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=revert-resized-server-revertresize-action-detail#revert-resized-server-revertresize-action
            def revert_resize_server( server_id )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: {
                        revertResize: nil
                    },
                    error_message: "Failed to revert resize virtual machine (server_id: #{server_id}, options: #{options})."
                ) do | res |
                    server_id
                end
            end

            # Gets the connection URL of VNC html5 console client (noVNC).
            #
            # @param [String]    server_id   Server ID
            #
            # @return [String]              When succeeded, VNC console connection url.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-vnc_console.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=get-vnc-console-os-getvncconsole-action-deprecated-detail#get-vnc-console-os-getvncconsole-action-deprecated
            def get_vnc_console_url( server_id )
                get_console_url_core( server_id, target_console: { :'os-getVNCConsole' => { :type => "novnc" } } )
            end

            # Gets a connection URL of web serial console.
            #
            # @param [String]    server_id   Server ID
            #
            # @return [String]              When succeeded, web serial console connection url.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-web_serial_console.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=get-serial-console-os-getserialconsole-action-deprecated-detail#get-serial-console-os-getserialconsole-action-deprecated
            def get_web_serial_console_url( server_id )
                get_console_url_core( server_id, target_console: { :'os-getSerialConsole' => { :type => "serial" } } )
            end

            # Gets a connection URL of web serial console (HTTP).
            #
            # @param [String]    server_id   Server ID
            #
            # @return [String]              When succeeded, web serial console connection url.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-web_http_serial_console.html
            def get_web_http_serial_console_url( server_id )
                get_console_url_core( server_id, target_console: { :'os-getWebConsole' => { :type => "serial" } } )
            end

            # Gets a connection URL of web serial console.
            #
            # @param [String]    server_id   Server ID
            #
            # @return [String]              When succeeded, VNC console connection url.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-web_serial_console.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=get-serial-console-os-getserialconsole-action-deprecated-detail#get-serial-console-os-getserialconsole-action-deprecated
            def get_web_serial_console_url( server_id )
                get_console_url_core( server_id, target_console: { :'os-getSerialConsole' => { :type => "serial" } } )
            end

            # Creates a new server image.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   image_name      Image name  
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note Target virtual machine must be stopped.
            #
            # @see https://www.conoha.jp/docs/compute-create_image.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=create-image-createimage-action-detail#create-image-createimage-action
            def create_server_image( server_id, image_name: )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action", 
                    body: {
                        createImage: {
                            name: image_name
                        }
                    },
                    error_message: "Failed to create server image (server_id: #{server_id}, image_name: #{image_name})."
                ) do | res |
                    server_id
                end
            end

            # Changes the storage controller.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   hw_disk_bus     Disk bus ( "virtio", "scsi" or "ide" )
            #
            # @note Target virtual machine must be stopped.
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-hw_disk_bus.html
            def change_storage_controller( server_id, hw_disk_bus: "virtio" )
                change_vm_hardware_core( server_id, target_hw: { hwDiskBus: hw_disk_bus } )
            end

            # Changes the network adapter.
            #
            # @param [String]   server_id           Server ID
            # @param [String]   hw_vif_model        Network adapter ( "e1000", "virtio" or "rtl8139" )
            #
            # @note Target virtual machine must be stopped.
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-hw_vif_model.html
            def change_network_adapter( server_id, hw_vif_model: "virtio" )
                change_vm_hardware_core( server_id, target_hw: { hwVifModel: hw_vif_model } )
            end

            # Changes the video device.
            #
            # @param [String]   server_id           Server ID
            # @param [String]   hw_video_model      Video device ( "qxl", "vga" or "cirrus" )
            #
            # @note Target virtual machine must be stopped.
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-hw_video_model.html
            def change_video_device( server_id, hw_video_model: "vga" )
                change_vm_hardware_core( server_id, target_hw: { hwVideoModel: hw_video_model } )
            end

            # Changes the console key map.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   vnc_keymap      Video device ( "en-us" or "ja" )
            #
            # @note Target virtual machine must be stopped.
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-vnc_key_map.html
            def change_key_map( server_id, vnc_keymap: )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action", 
                    body: {
                        vncKeymap: vnc_keymap
                    },
                    error_message: "Failed to change console key map (server_id: #{server_id}, vncKeymap: #{vnc_keymap})."
                ) do | res |
                    server_id
                end
            end

            # Mounts a ISO image to virtual machine.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   iso_path        ISO image file path
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note Target virtual machine must be stopped.
            #
            # @see https://www.conoha.jp/docs/compute-insert_iso_image.html
            def mount_iso_image( server_id, iso_path: )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: {
                        mountImage: iso_path
                    },
                    error_message: "Failed to mount (server_id: #{server_id}, iso_path: #{iso_path})."
                ) do | res |
                    server_id
                end
            end

            # Unmounts the ISO image from virtual machine.
            #
            # @param [String]   server_id       Server ID
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note Target virtual machine must be stopped.
            #
            # @see https://www.conoha.jp/docs/compute-eject_iso_image.html
            def unmount_iso_image( server_id )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action", 
                    body: {
                        unmountImage: ""
                    },
                    error_message: "Failed to unmount (server_id: #{server_id})." 
                ) do | res |
                    server_id
                end
            end

            # Gets a security group list assigned to the virtual machine
            #
            # @param [String]   server_id       Server ID
            #
            # @return [Nocoah::Type::Compute::SecurityGroup]    When succeeded, security group list.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see https://www.conoha.jp/docs/compute-get_secgroups_status.html
            def get_security_group_list( server_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-security-groups",
                    error_message: "Failed to get security group list (server_id: #{server_id})."
                )
            end

            # Gets a key-pair list.
            #
            # @return [Array<Nocoah::Types::Compute::KeyPairItem>]      When succeeded, key-pair list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_keypair_detail
            # @see https://www.conoha.jp/docs/compute-get_keypairs.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-keypairs-detail#list-keypairs
            def get_keypair_list
                json_data = api_get( 
                    "/#{@identity.config.tenant_id}/os-keypairs", 
                    error_message: "Failed to get key-pair list."
                )
                return [] unless json_data.key?( 'keypairs' )

                json_data['keypairs'].map() do | keypair |
                    Types::Compute::KeyPairItem.new( keypair['keypair'] )
                end
            end

            # Gets a key-pair item detail.
            #
            # @return [Nocoah::Types::Compute::KeyPairItemDetail]       When succeeded, key-pair detail item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_keypair_list
            # @see https://www.conoha.jp/docs/compute-get_keypairs_detail_specified.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-keypair-details-detail#show-keypair-details
            def get_keypair_detail( keypair_name )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/os-keypairs/#{keypair_name}", 
                    error_message: "Failed to get key-pair item detail (keypair_name: #{keypair_name})." 
                )
                return nil unless json_data.key?( 'keypair' )

                Types::Compute::KeyPairItemDetail.new( json_data['keypair'] )
            end

            # Adds a key-pair.
            #
            # @param [String]   keypair_name        Key-pair name
            # @param [String]   public_key          Public key ( When nil with public_key_path, the key is generated on the Nova side. )
            # @param [String]   public_key_path     Public key file path ( If specified together with public_key, public_key takes precedence. )
            #
            # @return [Nocoah::Types::Compute::AddKeyPairResult]        When succeeded, added key-pair result info.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @note If you create a key on the Nova side, the private key can only be obtained via this return value. 
            #       Make sure to save this, as there is no way to get this private key again in the future.
            #
            # @see https://www.conoha.jp/docs/compute-add_keypair.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=create-or-import-keypair-detail#create-or-import-keypair
            def add_keypair( keypair_name, public_key: nil, public_key_path: nil )
                body = {
                    keypair: {
                        name: keypair_name
                    }
                }
                if !public_key.nil?
                    body[:keypair][:public_key] = public_key
                elsif !public_key_path.nil?
                    body[:keypair][:public_key] = File.read( public_key_path )
                end
        
                json_data = api_post( 
                    "/#{@identity.config.tenant_id}/os-keypairs",
                    body: body
                    error_message: "Failed to add key-pair (keypair_name: #{keypair_name}, public_key: #{public_key}, public_key_path: #{public_key_path})."
                )
                return nil unless json_data.key?( 'keypair' )

                Types::Compute::AddKeyPairResult.new( json_data['keypair'] )
            end

            # Deletes the key-pair.
            #
            # @param [String]   keypair_name    Key-pair name
            #
            # @return [String]              When succeeded, deleted key-pair name.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-delete_keypair.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=create-or-import-keypair-detail#create-or-import-keypair
            def delete_keypair( keypair_name )
                api_delete(
                    "#{@endpoint}/#{@identity.config.tenant_id}/os-keypairs/#{keypair_name}",
                    error_message: "Failed to delete key-pair (keypair_name: #{keypair_name})."
                ) do | res |
                    keypair_name
                end
            end

            # Gets a attached volume list.
            #
            # @param [String]   server_id       Server ID
            #
            # @return [Array<Nocoah::Types::Compute::AttachedVolumeItem>]       When succeeded, attached volume list.
            # @raise [Nocoah::APIError]                                         When failed.
            #
            # @see get_attached_volume_item
            # @see https://www.conoha.jp/docs/compute-get_volume_attachments.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-volume-attachments-for-an-instance-detail#list-volume-attachments-for-an-instance
            def get_attached_volume_list( server_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-volume_attachments",
                    error_message: "Failed to get attached volume list (server_id: #{server_id})."
                )
                return [] unless json_data.key?( 'volumeAttachments' )

                json_data['volumeAttachments'].map do | volume |
                    Types::Compute::AttachedVolumeItem.new( volume )
                end
            end

            # Gets a attached volume item.
            #
            # @param [String]   server_id           Server ID
            # @param [String]   attachment_id       Attachment ID
            #
            # @return [Nocoah::Types::Compute::AttachedVolumeItem]      When succeeded, attached volume item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_attached_volume_list
            # @see https://www.conoha.jp/docs/compute-get_volume_attachment_specified.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-a-detail-of-a-volume-attachment-detail#show-a-detail-of-a-volume-attachment
            def get_attached_volume_item( server_id, attachment_id: )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-volume_attachments/#{attachment_id}",
                    error_message: "Failed to get attached volume item (server_id: #{server_id}, attachment_id: #{attachment_id})."
                )
                return nil unless json_data.key?( 'volumeAttachment' )

                Types::Compute::AttachedVolumeItem.new( json_data['volumeAttachment'] )
            end

            # Attaches a volume to the virtual machine.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   volume_id       Volume ID
            #
            # @return [Nocoah::Types::Compute::AttachedVolumeItem]      When succeeded, attached volume item.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @note Target virtual machine must be stopped.
            # @note As ConoHa is possible to attach only one additional disk, device is always specified as "/dev/vdb".
            #       If the target virtual machine is already attached to another volume, cannot attach.
            #
            # @see detach_volume
            # @see https://www.conoha.jp/docs/compute-attach_volume.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=attach-a-volume-to-an-instance-detail#attach-a-volume-to-an-instance
            def attach_volume( server_id, volume_id: )
                json_data = api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-volume_attachments", 
                    body: {
                        volumeAttachment: {
                            volumeId: volume_id,
                            device: "/dev/vdb"
                        }
                    }, 
                    error_message: "Failed to get attach volume (server_id: #{server_id}, volume_id: #{volume_id})."
                )
                return nil unless json_data.key?( 'volumeAttachment' )

                Nocoah::Types::Compute::AttachedVolumeItem.new( json_data['volumeAttachment'] )
            end

            # Detaches the volume from the virtual machine.
            #
            # @param [String]   server_id           Server ID
            # @param [String]   attachment_id       Attachment ID
            #
            # @return [String]              When succeeded, detached server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note Target virtual machine must be stopped.
            #
            # @see attach_volume
            # @see https://www.conoha.jp/docs/compute-dettach_volume.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=detach-a-volume-from-an-instance-detail#detach-a-volume-from-an-instance
            def detach_volume( server_id, attachment_id: )
                api_delete(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-volume_attachments/#{attachment_id}",
                    error_message: "Failed to get detach volume (server_id: #{server_id}, attachment_id: #{attachment_id})."
                ) do | res |
                    server_id
                end
            end

            # Gets a attached interface list.
            #
            # @param [String]   server_id       Server ID
            #
            # @return [Array<Nocoah::Types::Compute::AttachedInterfaceItem>]        When succeeded, attached interface list.
            # @raise [Nocoah::APIError]                                             When failed.
            #
            # @see get_attached_interface_item
            # @see https://www.conoha.jp/docs/compute-get_attached_ports_list.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-port-interfaces-detail#list-port-interfaces
            def get_attached_interface_list( server_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-interface",
                    error_message: "Failed to get attached interface list (server_id: #{server_id})."
                )
                return [] unless json_data.key?( 'interfaceAttachments' )

                json_data['interfaceAttachments'].map do | interface |
                    Types::Compute::AttachedInterfaceItem.new( interface )
                end
            end

            # Gets a attached interface item.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   port_id         Port ID
            #
            # @return [Nocoah::Types::Compute::AttachedInterfaceItem]       When succeeded, attached interface item.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_attached_interface_list
            # @see https://www.conoha.jp/docs/compute-get_attached_port_specified.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-port-interface-details-detail#show-port-interface-details
            def get_attached_interface_item( server_id, port_id: )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-interface/#{port_id}",
                    error_message: "Failed to get attached interface item (server_id: #{server_id}, port_id: #{port_id})."
                )
                return nil unless json_data.key?( 'interfaceAttachment' )

                Types::Compute::AttachedInterfaceItem.new( json_data['interfaceAttachment'] )
            end

            # Attaches a interface to the virtual machine.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   port_id         Port ID
            #
            # @return [Nocoah::Types::Compute::AttachedInterfaceItem]       When succeeded, attached interface item.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @note Target virtual machine must be stopped.
            # @note In ConoHa, the number of interfaces that can be connected is as follows.
            #   {
            #       'Additional IP port': 1,
            #       'Local network IP port': 2,
            #       'Network port for DB server connection': 1
            #   }
            #
            # @see detach_interface
            # @see https://www.conoha.jp/docs/compute-attach_port.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=create-interface-detail#create-interface
            def attach_interface( server_id, port_id: )
                json_data = api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-interface",
                    body: {
                        interfaceAttachment: {
                            port_id: port_id
                        }
                    },
                    error_message: "Failed to get attach interface (server_id: #{server_id}, port_id: #{port_id})."
                )
                return nil unless json_data.key?( 'interfaceAttachment' )

                Types::Compute::AttachedInterfaceItem.new( json_data['interfaceAttachment'] )
            end

            # Detaches the interface from the virtual machine.
            #
            # @param [String]   server_id       Server ID
            # @param [String]   port_id         Port ID
            #
            # @return [String]              When succeeded, detached server ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @note Target virtual machine must be stopped.
            #
            # @see attach_interface
            # @see https://www.conoha.jp/docs/compute-dettach_port.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=detach-interface-detail#detach-interface
            def detach_interface( server_id, port_id: )
                api_delete(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/os-interface/#{port_id}",
                    error_message: "Failed to get detach interface (server_id: #{server_id}, port_id: #{port_id})."
                ) do | res |
                    server_id
                end
            end

            # Gets a virtual machine metadata.
            #
            # @param [String]   server_id       Server ID
            #
            # @return [Hash]                When succeeded, virtual machine metadata.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-get_server_metadata.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-all-metadata-detail#list-all-metadata
            def get_server_metadata( server_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/metadata",
                    error_message: "Failed to get metadata (server_id: #{server_id})."
                )
                json_data['metadata']
            end

            # Sets the virtual machine metadata.
            #
            # @param            [String]    server_id           Server ID
            # @param            [Hash]      metadata            Server metadata to set
            # @option metadata  [String]    instance_name_tag   Name tag
            #
            # @return [Hash]                When succeeded, virtual machine metadata.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/compute-update_metadata.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=replace-metadata-items-detail#replace-metadata-items
            def set_server_metadata( server_id, **metadata )
                json_data = api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/metadata",
                    body: {
                        metadata: metadata
                    },
                    "Failed to set metadata (server_id: #{server_id}, metadata: #{metadata})."
                )
                json_data['metadata']
            end

            # Gets a virtual machine addresses.
            #
            # @param [String]   server_id       Server ID
            #
            # @return [Array<Nocoah::Types::Compute::ServerNetworkItem>]    When succeeded, virtual machine addresses.
            # @raise [Nocoah::APIError]                                     When failed.
            #
            # @see get_server_addresses_by_network
            # @see https://www.conoha.jp/docs/compute-get_server_addresses.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=list-ips-detail#list-ips
            def get_server_addresses( server_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/ips",
                    error_message: "Failed to get addresses (server_id: #{server_id})."
                )
                return [] unless json_data.key?( 'addresses' )
                
                json_data['addresses'].map do | label, ips |
                    Nocoah::Types::Compute::ServerNetworkItem.new( label, ips )
                end
            end

            # Gets a virtual machine addresses.
            #
            # @param [String]   server_id           Server ID
            # @param [String]   network_label       Network label
            #
            # @return [Nocoah::Types::Compute::ServerNetworkItem]       When succeeded, virtual machine addresses.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_server_addresses
            # @see https://www.conoha.jp/docs/compute-get_server_addresses_by_network.html
            # @see https://developer.openstack.org/api-ref/compute/?expanded=show-ip-details-detail#show-ip-details
            def get_server_addresses_by_network( server_id, network_label: )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/ips/#{network_label}",
                    error_message: "Failed to get addresses (server_id: #{server_id}, network_label: #{network_label})."
                )
                return nil unless json_data.key?( network_label )
                
                Types::Compute::ServerNetworkItem.new( network_label, json_data[network_label] )
            end

            # Gets a virtual machine cpu utilization rrd.
            #
            # @param            [String]    server_id           Server ID
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, virtual machine cpu utilization rrd.
            # @raise [Nocoah::APIError]                 When failed.
            #
            # @see https://www.conoha.jp/docs/compute-get_cpu_utilization_graph.html
            def get_server_cpu_rrd( server_id, **url_query )
                url_query[:target_rrd] = "cpu"
                url_query[:error_message] = "Failed to get cpu utilization rrd (server_id: #{server_id}, url_query: #{url_query})."
                get_server_rrd_core( server_id, url_query )
            end

            # Gets a virtual machine interface traffic rrd.
            #
            # @param            [String]    server_id           Server ID
            # @param            [String]    port_id             Port ID
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, virtual machine interface traffic rrd.
            # @raise [Nocoah::APIError]                 When failed.
            #
            # @see https://www.conoha.jp/docs/compute-get_interface_traffic_graph.html
            def get_server_interface_rrd( server_id, port_id:, **url_query )
                url_query[:target_rrd] = "interface"
                url_query[:error_message] = "Failed to get interface traffic rrd (server_id: #{server_id}, port_id: #{port_id}, url_query: #{url_query})."
                url_query[:port_id] = port_id
                get_server_rrd_core( server_id, url_query )
            end

            # Gets a virtual machine disk utilization rrd.
            #
            # @param            [String]    server_id           Server ID
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [String]    device              ("vda") Disk device name
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method ( 'average', 'max' or 'min' )
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, virtual machine disk utilization rrd.
            # @raise [Nocoah::APIError]                 When failed.
            #
            # @see https://www.conoha.jp/docs/compute-get_disk_io_graph.html
            def get_server_disk_rrd( server_id, **url_query )
                url_query[:target_rrd] = "disk"
                url_query[:error_message] = "Failed to get disk utilization rrd (server_id: #{server_id}, url_query: #{url_query})."
                get_server_rrd_core( server_id, url_query )
            end

            # Gets a backup list.
            #
            # @return [Array<Nocoah::Types::Compute::BackupItem>]       When succeeded, backup list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see get_backup_item
            # @see https://www.conoha.jp/docs/backup-get_backup_list.html
            def get_backup_list
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/backup",
                    error_message: "Failed to get backup list."
                )
                return [] unless json_data.key?( 'backup' )
                
                json_data['backup'].map do | bk |
                    Types::Compute::BackupItem.new( bk )
                end
            end

            # Gets a backup item.
            #
            # @param [String]   backup_id       Backup ID
            #
            # @return [Nocoah::Types::Compute::BackupItem]      When succeeded, backup item.
            # @raise [Nocoah::APIError]                         When failed.
            #
            # @see get_backup_list
            # @see https://www.conoha.jp/docs/backup-get_backup_list_detailed.html
            def get_backup_item( backup_id )
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/backup/#{backup_id}",
                    error_message: "Failed to get backup item (backup_id: #{backup_id})."
                )
                return nil unless json_data.key?( 'backup' )
                
                Types::Compute::BackupItem.new( json_data['backup'] )
            end

            # Starts a backup.
            #
            # @param [String]   server_id       Server ID
            #
            # @note ConoHa: Enables the option "Automatic backup". (Note: Not available with the 512MB plan.)
            #
            # @return [Nocoah::Types::Compute::StartBackupResult]       When succeeded, start backup result.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see end_server_backup
            # @see https://www.conoha.jp/docs/backup-start_backup.html
            # @see https://www.conoha.jp/vps/pricing/
            def start_server_backup( server_id )
                json_data = api_post(
                    "/#{@identity.config.tenant_id}/backup",
                    body: {
                        backup: {
                            instance_id: server_id
                        }
                    },
                    error_message:  "Failed to start backup (server_id: #{server_id})."
                )
            end

            # Ends the backup.
            #
            # @param [String]   backup_id       Backup ID to stop backup
            #
            # @note ConoHa: Disables the option "Automatic backup".
            #
            # @return [String]              When succeeded, ended backup ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see start_server_backup
            # @see https://www.conoha.jp/docs/backup-end_backup.html
            def end_server_backup( backup_id )
                api_delete(
                    "/#{@identity.config.tenant_id}/backup/#{backup_id}",
                    error_message: "Failed to stop backup (backup_id: #{backup_id})."
                ) do | res |
                    backup_id
                end
            end

            # Restores from the backup.
            #
            # @param [String]   backup_id       Backup ID to use with restore
            # @param [String]   backuprun_id    Backup run ID to use with restore
            #
            # @note Target virtual machine must be stopped.
            #
            # @return [String]              When succeeded, restored backup ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/backup-restore_backup.html
            def restore_server_backup( backup_id, backuprun_id: )
                api_post(
                    "/#{@identity.config.tenant_id}/backup/#{backup_id}/action",
                    body: {
                        restore: {
                            backuprun_id: backuprun_id
                        }
                    },
                    error_message: "Failed to restore backup (backup_id: #{backup_id}, backuprun_id: #{backuprun_id})."
                ) do | res |
                    backup_id
                end
            end

            # Saves the backup to an image.
            #
            # @note Not available in current version.
            #
            # @param [String]   backup_id       Backup ID to save
            # @param [String]   backuprun_id    Backup run ID to save
            # @param [String]   image_name      Image name
            #
            # @return [String]              When succeeded, saved backup ID.
            # @raise [Nocoah::APIError]     When failed.
            #
            # @see https://www.conoha.jp/docs/backup-backup_to_image_object.html
            # def save_server_backup_to_image( backup_id, backuprun_id:, image_name: )
            #     api_post(
            #         "/#{@identity.config.tenant_id}/backup/#{backup_id}/action",
            #         body: {
            #             createImage: {
            #                 backuprun_id: backuprun_id,
            #                 image_name: image_name
            #             }
            #         },
            #         error_message: "Failed to save backup (backup_id: #{backup_id}, backuprun_id: #{backuprun_id}, image_name: #{image_name})."
            #     ) do | res |
            #         backup_id
            #     end
            # end

            # Gets a ISO image list.
            #
            # @return [Array<Nocoah::Types::Compute::ISOImageItem>]     When succeeded, ISO image list.
            # @raise [Nocoah::APIError]                                 When failed.
            #
            # @see https://www.conoha.jp/docs/compute-iso-list-show.html
            def get_iso_image_list
                json_data = api_get(
                    "/#{@identity.config.tenant_id}/iso-images",
                    error_message: "Failed to get ISO image list."
                )
            end

            private

            # Gets a virtual machine template ( flavor ) list.
            #
            # @param            [Boolean]   is_detail   When true, gets detail list
            # @param            [Hash]      url_query   Options
            # @option url_query [Integer]   min_disk    Filter by minimum disk size (GB)
            # @option url_query [Integer]   min_ram     Filter by minimum ram size (GB)
            # @option url_query [Integer]   limit       Number of item
            #
            # @return [Hash]                When succeeded, flavor list.
            # @raise [Nocoah::APIError]     When failed.
            def get_flavor_list_core( is_detail = false, **url_query )
                uri = URI.parse( "/#{@identity.config.tenant_id}/flavors#{is_detail ? "/detail" : ""}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?
        
                api_get( uri.to_s, error_message: "Failed to get flavor #{is_detail ? "detail list" : "list"} (url_query: #{url_query})." )
            end

            # Gets a virtual machine list.
            #
            # @param            [Boolean]   is_detail       When true, gets detail list
            # @param            [Hash]      url_query       Options
            # @option url_query [DateTime]  changes-since   Virtual machine list ( including deleted ) from specified time
            # @option url_query [String]    image           Image ID
            # @option url_query [String]    flavor          Flavor ID
            # @option url_query [String]    name            Virtual machine name
            # @option url_query [String]    marker          Last-seen virtual machine ID
            # @option url_query [String]    limit           Number of item
            # @option url_query [String]    status          Virtual machine status
            #
            # @return [Hash]                When succeeded, virtual machine list.
            # @raise [Nocoah::APIError]     When failed.
            # @raise [ArgmentError]         When specified 'changes-since' is invalid type.
            def get_server_list_core( is_detail = false, **url_query )
                url_query_org = url_query.dup
                if url_query.key?( :'changes-since' )
                    if url_query[:'changes-since'].kind_of?( String )
                        url_query[:'changes-since'] = DateTime.parse( url_query[:'changes-since'] ).iso8601
                    elsif url_query[:'changes-since'].kind_of?( DateTime ) || url_query[:'changes-since'].kind_of?( Date ) || url_query[:'changes-since'].kind_of?( Time )
                        url_query[:'changes-since'] = url_query[:'changes-since'].iso8601
                    else
                        raise ArgumentError, "Invalid 'changes-since' type: #{url_query[:'changes-since']}"
                    end
                end

                uri = URI.parse( "#{@endpoint}/#{@identity.config.tenant_id}/servers#{is_detail ? "/detail" : ""}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?
        
                api_get( uri.to_s, error_message: "Failed to get server #{is_detail ? "detail list" : "list"} (url_query: #{url_query_org})." )
            end

            # Gets a image list.
            #
            # @param            [Boolean]   is_detail       When true, gets detail list
            # @param            [Hash]      url_query       Options
            # @option url_query [DateTime]  changes-since   Image list ( including deleted ) from specified time
            # @option url_query [String]    name            Image name
            # @option url_query [String]    status          Image status
            # @option url_query [String]    marker          Last-seen image ID
            # @option url_query [String]    limit           Number of item
            # @option url_query [String]    type            Image type
            #
            # @return [Hash]                When succeeded, image list.
            # @raise [Nocoah::APIError]     When failed.
            # @raise [ArgmentError]         When specified 'changes-since' is invalid type.
            def get_image_list_core( is_detail = false, **url_query )
                url_query_org = url_query.dup
                if url_query.key?( :'changes-since' )
                    if url_query[:'changes-since'].kind_of?( String )
                        url_query[:'changes-since'] = DateTime.parse( url_query[:'changes-since'] ).iso8601
                    elsif url_query[:'changes-since'].kind_of?( DateTime ) || url_query[:'changes-since'].kind_of?( Date ) || url_query[:'changes-since'].kind_of?( Time )
                        url_query[:'changes-since'] = url_query[:'changes-since'].iso8601
                    else
                        raise ArgumentError, "Invalid 'changes-since' type: #{url_query[:'changes-since']}"
                    end
                end

                uri = URI.parse( "#{@endpoint}/#{@identity.config.tenant_id}/images#{is_detail ? "/detail" : ""}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?

                api_get( uri.to_s, error_message: "Failed to get image #{is_detail ? "detail list" : "list"} (url_query: #{url_query_org})." )
            end

            # Launches, restarts or stops the virtual machine
            #
            # @param [String]   server_id       Server ID
            # @param [String]   action_name     Action name ( "launch" / "restart" / "stop" / "force-stop" )
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            def server_action_core( server_id, action_name )
                case action_name
                when "launch" then
                    body = { 'os-start': nil }
                when "restart" then
                    body = { reboot: { type: "SOFT" } }
                when "stop" then
                    body = { 'os-stop': nil }
                when "force-stop" then
                    body = { 'os-stop': { force_shutdown: true } }
                end

                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: body,
                    error_message: "Failed to #{action_name} virtual machine (server_id: #{server_id})."
                ) do | res |
                    server_id
                end
            end

            # Gets a console connection url.
            #
            # @param [String]   server_id           Server ID
            # @param [Hash]     target_console      Target console
            #
            # @return [String]              When succeeded, console connection url.
            # @raise [Nocoah::APIError]     When failed.
            def get_console_url_core( server_id, target_console: )
                json_data = api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: target_console,
                    error_message: "Failed to get console connection url (server_id: #{server_id})."
                )

                json_data['console']['url']
            end

            # Changes the virtual machine hardware.
            #
            # @param [String]   server_id       Server ID
            # @param [Hash]     target_hw       Target hardware
            #
            # @return [String]              When succeeded, server ID.
            # @raise [Nocoah::APIError]     When failed.
            def change_vm_hardware_core( server_id, target_hw: )
                api_post(
                    "/#{@identity.config.tenant_id}/servers/#{server_id}/action",
                    body: target_hw,
                    error_message: "Failed to change hardware (server_id: #{server_id}, target_hw: #{target_hw})."
                ) do | res |
                    server_id
                end
            end

            # Gets a virtual machine rrd.
            #
            # @param            [String]    server_id           Server ID
            # @param            [String]    target_rrd          Target RRD ( 'cpu', 'interface' or 'disk' )
            # @param            [String]    error_message       Error message when failed
            # @param            [Hash]      url_query           Optional parameter
            # @option url_query [Integer]   start_date_raw      (1 day ago) Data acquisition start time (UNIX time)
            # @option url_query [Integer]   end_date_raw        (1 day ago) Data acquisition end time (UNIX time)
            # @option url_query [String]    mode                ("average") Data integration method
            #
            # @note When start_date_raw or end_date_raw is specified in Date, Time or DateTime type, converts to UNIX time.
            #
            # @return [Nocoah::Types::Common::RRD]      When succeeded, virtual machine rrd.
            # @raise [Nocoah::APIError]                 When failed.
            def get_server_rrd_core( server_id, target_rrd:, error_message:, **url_query )
                # When specified in Date, Time or DateTime type, converts to UNIX time.
                url_query[:start_date_raw] = url_query[:start_date_raw].to_i if Types::Common.kind_of_date_or_time?( url_query[:start_date_raw] )
                url_query[:end_date_raw] = url_query[:end_date_raw].to_i if Types::Common.kind_of_date_or_time?( url_query[:end_date_raw] )

                uri = URI.parse( "#{@endpoint}/#{@identity.config.tenant_id}/servers/#{server_id}/rrd/#{target_rrd}" )
                uri.query = URI.encode_www_form( url_query ) if !url_query.empty?
        
                json_data = api_get( uri.to_s, error_message: error_message )
                return nil unless json_data.key?( target_rrd )
                
                Types::Common::RRD.new( target_rrd, json_data[target_rrd] )
            end

        end

    end

end