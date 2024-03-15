class WavFile
  DEFAULT_FORMAT = 'Compressed'
  FORMATS = {
    pcm: 'PCM'
  }

  attr_reader :sample_format, :format, :channel_count, :sample_rate,
              :byte_rate, :bit_depth, :bit_rate

  def initialize(attributes ={})
    attributes.each do |key, val|
      instance_variable_set("@#{key}", val)
    end

    @format = FORMATS[sample_format] || DEFAULT_FORMAT
    @bit_rate = sample_rate * channel_count * bit_depth
  end

  def to_hash
    {
      format: format,
      channel_count: channel_count,
      sample_rate: sample_rate,
      byte_rate: byte_rate,
      bit_depth: bit_depth,
      bit_rate: bit_rate
    }
  end
end
