class FileReader
  HEADER_BYTES = 36
  attr_reader :filepath

  def initialize(filepath:)
    @filepath = filepath
  end

  def call
    header = File.read(filepath, HEADER_BYTES)

    {
      sample_format: header[20...22].unpack('v').first,
      channel_count: header[22...24].unpack('v').first,
      sample_rate: header[24...28].unpack('V').first,
      byte_rate: header[28...32].unpack('V').first,
      bits_per_sample: header[34...36].unpack('v').first
    }
  end
end
