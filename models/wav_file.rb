class WavFile
  COMPRESSED_FORMAT = 'Compressed'
  PCM_FORMAT = 'PCM'

  attr_reader :sample_format, :channel_count, :sample_rate,
              :byte_rate, :bits_per_sample

  def initialize(attributes = {})
    attributes.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def to_hash
    {
      format: format,
      channel_count: channel_count,
      sampling_rate: sample_rate,
      byte_rate: byte_rate,
      bit_depth: bits_per_sample,
      bit_rate: bit_rate
    }
  end

  private

  def format
    return PCM_FORMAT if sample_format == 1
    COMPRESSED_FORMAT
  end

  def bit_rate
    sample_rate * channel_count * bits_per_sample
  end
end
