# Nocoah
module Nocoah

    # Endpoints
    module Endpoints

        # Public cloud key
        module PublicCloudKey
            # ConoHa
            CONOHA = :conoha
        end

        # Endpoint list
        @@endpoints = {
            # ConoHa ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            PublicCloudKey::CONOHA => {
                identity: "https://identity.%s.conoha.io/v2.0",
                account: "https://account.%s.conoha.io/v1",
                compute: "https://compute.%s.conoha.io/v2",
                block_storage: "https://block-storage.%s.conoha.io/v2",
                image: "https://image-service.%s.conoha.io/v2",
                network: "https://networking.%s.conoha.io/v2.0",
                object_storage: "https://object-storage.%s.conoha.io/v1",
                database: "https://database-hosting.%s.conoha.io/v1",
                dns: "https://dns-service.%s.conoha.io/v1",
                mail: "https://mail-hosting.%s.conoha.io/v1"
            },
        }

        # Gets an API endpoint list.
        def self.get_endpoints( public_cloud_key )
            @@endpoints[public_cloud_key]
        end

        # Gets a public cloud key.
        def self.get_public_cloud_key( name )
            case name
            # ConoHa, conoha, CONOHA, conoha.io
            when /(conoha|ConoHa|CONOHA)(\.io)?/
                public_cloud_key = PublicCloudKey::CONOHA
            # Z, z, z.com
            when /[Zz](\.com)?/
                public_cloud_key = PublicCloudKey::Z_COM
            else
                public_cloud_key = nil
            end

            public_cloud_key
        end

    end

end