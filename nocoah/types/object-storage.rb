Dir["#{File.dirname( __FILE__ )}/object-storage/*.rb"].each do | file |
    require file
end