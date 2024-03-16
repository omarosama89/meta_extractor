#!/usr/bin/env ruby

require_relative './get_meta_data_from_directory'
require_relative './store_meta_data'

directory = ARGV[0]
output_directory = ARGV[1]

meta_data_monad = GetMetaDataFromDirectory.new(directory: directory).call

if meta_data_monad.failure?
  puts meta_data_monad.failure
  exit
end

store_meta_data_monad = StoreMetaData.new(xml_map: meta_data_monad.value!, output_directory: output_directory).call

if store_meta_data_monad.failure?
  puts store_meta_data_monad.failure
  exit
end

puts store_meta_data_monad.value!
