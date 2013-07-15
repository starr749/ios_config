require 'core_ext/string'
Gem.find_files("ios_config/**/*.rb").each { |path| require path }
