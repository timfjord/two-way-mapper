describe ActiveMapping::Map do
  describe '#register' do
    let(:map) { ActiveMapping::Map.new }

    it 'should raise error when no or empty hash passed' do
      expect{map.register :mapping_name}.to raise_error
      expect{map.register :mapping_name, 1}.to raise_error
      expect{map.register :mapping_name, {}}.to raise_error
      expect{map.register :mapping_name, test: nil}.to raise_error
      expect{map.register :mapping_name, nil => :test}.to raise_error
    end

    it 'should register new mapping' do
      map.register :import, object: :hash

      mapping = map[:import]
      expect(mapping).to be_instance_of ActiveMapping::Mapping
    end
  end
end
