#!/usr/bin/env ruby

BASE_OUTPUT_DIRECTORY = 'output'

require 'pry'
require 'wavefile'
require 'gyoku'

require_relative './models/wav_file'

ext = 'wav'
directory = 'input_files'

def get_xml_filepath(filepath)
  filename = File.basename(filepath, ".*")
  "#{BASE_OUTPUT_DIRECTORY}/#{Time.now.to_i}/#{filename}.xml"
end

directory = ARGV[0] || directory
ext = ARGV[1] || ext

raise Exception.new "Directory passed doesn't exist" unless File.exist?(directory.to_s)

files = Dir.glob(File.join(directory, '**', "*.#{ext}"))

files.each do |filepath|
  wfr = WaveFile::Reader.new(filepath)
  wav_file = WavFile.new(
    sample_format: wfr.format.sample_format,
    channel_count: wfr.format.channels,
    sample_rate: wfr.format.sample_rate,
    byte_rate: wfr.format.byte_rate,
    bit_depth: wfr.format.bits_per_sample
  )

  xml = Gyoku.xml({track: wav_file.to_hash}, pretty_print: true)

  xml_filepath = get_xml_filepath(filepath)

  FileUtils.mkdir_p(File.dirname(xml_filepath))

  File.open(xml_filepath, 'w') do |file|
    file << xml
  end

  puts "Successfully output saved to -> #{xml_filepath}."
end

