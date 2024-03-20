require_relative '../models/wav_file'
require_relative '../store_meta_data'
require 'gyoku'

RSpec.describe StoreMetaData do
  subject do
    described_class.new(xml_map: xml_map, output_directory: output_directory)
  end

  let(:xml_map) do
    {
      file_name => "file content <#{file_name}>"
    }
  end
  let(:file_name) { "file_name" }
  let(:output_directory) { 'spec/fixtures/dummy_output' }
  

  context "when xml_map is missing" do
    let(:xml_map) { nil }
    let(:error) { "missing argument xml_map" }

    it 'returns error' do
      expect(subject.call.failure).to eq(error)
    end
  end

  context "when directory exists" do
    it 'creates xml file with file_name' do
      expect{ subject.call }.to change { Dir.glob("#{output_directory}/**/#{file_name}.xml").count }.by(1)
    end
  end
end

