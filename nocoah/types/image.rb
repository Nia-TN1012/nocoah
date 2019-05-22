Dir["#{File.dirname( __FILE__ )}/image/*.rb"].each do | file |
    require file
end