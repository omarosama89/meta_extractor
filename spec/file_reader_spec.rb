require_relative '../file_reader'

RSpec.describe FileReader do
  subject do
    described_class.new(filepath: filepath)
  end

  let(:filepath) { 'path/to/file' }
  let(:result) do
    {
      sample_format: 1,
      channel_count: 2,
      sample_rate: 44100,
      byte_rate: 176400,
      bits_per_sample: 16
    }
  end
  let(:metadata_encoded) do
    "RIFF\xDAE\xA1\x00WAVEfmt \x10\x00\x00\x00\x01\x00\x02\x00D\xAC\x00\x00\x10\xB1\x02\x00\x04\x00\x10\x00"
  end

  before do
    allow(File).to receive(:read).with(filepath, described_class::HEADER_BYTES).and_return(metadata_encoded)
  end


  it 'returns result' do
    expect(subject.call).to match(result)
  end
end
