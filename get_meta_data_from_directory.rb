require 'wavefile'
require 'gyoku'
require 'dry/monads'
require_relative './models/wav_file'

class GetMetaDataFromDirectory
  include Dry::Monads[:result]

  DEFAULT_EXTENSION = 'wav'

  attr_reader :ext, :directory

  def initialize(attributes ={})
    @directory = attributes[:directory]
    @ext = attributes[:ext] || DEFAULT_EXTENSION
  end

  def call
    return Failure("directory doesn't exist") unless File.exist?(directory.to_s)

    files = Dir.glob(File.join(directory, '**', "*.#{ext}"))

    xml_filepaths = files.each_with_object({}) do |filepath, memo|
      wfr = WaveFile::Reader.new(filepath)

      wav_file = WavFile.new(
        sample_format: wfr.format.sample_format,
        channel_count: wfr.format.channels,
        sample_rate: wfr.format.sample_rate,
        byte_rate: wfr.format.byte_rate,
        bits_per_sample: wfr.format.bits_per_sample
      )

      xml = Gyoku.xml({track: wav_file.to_hash}, pretty_print: true)

      filename = File.basename(filepath, ".*")

      memo[filename] = xml
    end

    Success(xml_filepaths)
  end
end
