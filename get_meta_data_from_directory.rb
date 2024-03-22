require 'gyoku'
require 'dry/monads'
require_relative './file_reader'
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
      file_reader = FileReader.new(filepath: filepath)

      wav_file = WavFile.new(file_reader.call)

      xml = Gyoku.xml({track: wav_file.to_hash}, pretty_print: true)

      filename = File.basename(filepath, ".*")

      memo[filename] = xml
    end

    Success(xml_filepaths)
  end
end
