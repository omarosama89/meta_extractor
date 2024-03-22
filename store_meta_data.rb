require 'gyoku'
require 'dry/monads'
require_relative './models/wav_file'
require 'fileutils'

class StoreMetaData
  include Dry::Monads[:result]

  DEFAULT_OUTPUT_DIRECTORY = 'output'

  attr_reader :xml_map, :output_directory

  def initialize(attributes={})
    @xml_map = attributes[:xml_map]
    @output_directory = attributes[:output_directory] || DEFAULT_OUTPUT_DIRECTORY
  end

  def call
    return Failure("missing argument xml_map") unless xml_map

    FileUtils.mkdir_p(output_directory)

    xml_map.each do |name, xml|
      xml_filepath = get_xml_filepath(name)

      FileUtils.mkdir_p(File.dirname(xml_filepath))

      File.open(xml_filepath, 'w') do |file|
        file << xml
      end
    end

    Success("Successfully created #{xml_map.count} xml files")
  end

  private

  def get_xml_filepath(name)
    "#{output_directory}/#{Time.now.to_i}/#{name}.xml"
  end
end
