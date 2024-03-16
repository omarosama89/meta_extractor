require_relative '../../models/wav_file'
RSpec.describe WavFile do
  let(:channels) { 2 }
  let(:sample_rate) { 1200 }
  let(:byte_rate) { 1300 }
  let(:bits_per_sample) { 32 }
  let(:wav_file) do
    described_class.new(
      sample_format: sample_format,
      channel_count: channels,
      sample_rate: sample_rate,
      byte_rate: byte_rate,
      bits_per_sample: bits_per_sample
    )
  end
  let(:hash) do
    {
      format: format,
      channel_count: channels,
      sampling_rate: sample_rate,
      byte_rate: byte_rate,
      bit_depth: bits_per_sample,
      bit_rate: 76800
    }
  end

  describe "#to_hash" do
    context "when format is pcm" do
      let(:sample_format) { :pcm }
      let(:format) { described_class::FORMATS[sample_format] }

      it 'returns hash' do
        expect(wav_file.to_hash).to match(hash)
      end
    end

    context "when format is compressed" do
      let(:sample_format) { :compressed }
      let(:format) { described_class::DEFAULT_FORMAT }

      it 'returns hash' do
        expect(wav_file.to_hash).to match(hash)
      end
    end
  end
end
