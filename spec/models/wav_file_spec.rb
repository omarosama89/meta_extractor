require_relative '../../models/wav_file'

RSpec.describe WavFile do
  let(:filepath) { 'path/to/file' }
  let(:channels) { 2 }
  let(:sample_rate) { 44100 }
  let(:byte_rate) { 176400 }
  let(:bits_per_sample) { 16 }
  let(:attributes) do
    {
      sample_format: sample_format,
      channel_count: channels,
      sample_rate: sample_rate,
      byte_rate: byte_rate,
      bits_per_sample: bits_per_sample
    }
  end
  let(:hash) do
    {
      format: format,
      channel_count: channels,
      sampling_rate: sample_rate,
      byte_rate: byte_rate,
      bit_depth: bits_per_sample,
      bit_rate: 1411200
    }
  end

  subject do
    described_class.new(attributes)
  end

  describe "#to_hash" do
    context "when format is pcm" do
      let(:metadata_encoded) do
        "RIFF\xDAE\xA1\x00WAVEfmt \x10\x00\x00\x00\x01\x00\x02\x00D\xAC\x00\x00\x10\xB1\x02\x00\x04\x00\x10\x00"
      end
      let(:sample_format) { 1 }
      let(:format) { described_class::PCM_FORMAT }

      it 'returns hash' do
        expect(subject.to_hash).to match(hash)
      end
    end

    context "when format is compressed" do
      let(:metadata_encoded) do
        "RIFF\xDAE\xA1\x00WAVEfmt \x10\x00\x00\x00\x02\x00\x02\x00D\xAC\x00\x00\x10\xB1\x02\x00\x04\x00\x10\x00"
      end
      let(:sample_format) { 2 }
      let(:format) { described_class::COMPRESSED_FORMAT }

      it 'returns hash' do
        expect(subject.to_hash).to match(hash)
      end
    end
  end
end
