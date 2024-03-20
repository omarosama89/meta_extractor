require_relative '../models/wav_file'
require_relative '../get_meta_data_from_directory'
require 'gyoku'

RSpec.describe GetMetaDataFromDirectory do
  subject do
    described_class.new(directory: directory, ext: ext )
  end

  before do
    allow(Dir).to receive(:glob).with(File.join(directory, '**', "*.#{ext}")).and_return(files)
    files.each do |file|
      allow(FileReader).to receive(:new).with(filepath: file).and_return(instance_double('FileReader', call: file_reader_response))
      allow(WavFile).to receive(:new).with(file_reader_response).and_return(wav_file_attributes)
    end
    allow(Gyoku).to receive(:xml).with({track: wav_file_attributes}, pretty_print: true).and_return(dummy_xml)
  end

  let(:dummy_xml) { "<track>\n<format>Compressed</format>\n</track>" }
  let(:file) { 'file' }
  let(:files) { ["i/am/#{file}.wav"] }
  let(:directory) { 'spec/fixtures/dummy_input_files' }
  let(:ext) { 'wav' }

  let(:sample_format) { :pcm }
  let(:format) { "PCM" }
  let(:channels) { 2 }
  let(:sample_rate) { 44100 }
  let(:byte_rate) { 176400 }
  let(:bits_per_sample) { 16 }
  let(:bit_rate) { 1411200 }

  let(:file_reader_response) do
    {
      sample_format: sample_format,
      channels: channels,
      sample_rate: sample_rate,
      byte_rate: byte_rate,
      bits_per_sample: bits_per_sample,
    }
  end

  let(:wav_file_attributes) do
    {
      format: format,
      channel_count: channels,
      sampling_rate: sample_rate,
      byte_rate: byte_rate,
      bit_rate: bit_rate,
      bit_depth: bits_per_sample,
    }
  end

  context "when directory doesn't exist" do
    let(:directory) { 'doesnt_exist_directory' }
    let(:error) { "directory doesn't exist" }

    it 'returns error' do
      expect(subject.call.failure).to eq(error)
    end
  end

  context "when directory exists" do
    let(:result) do
      {
        file => dummy_xml
      }
    end

    it 'returns xml_map' do
      expect(subject.call.value!).to match(result)
    end
  end
end

