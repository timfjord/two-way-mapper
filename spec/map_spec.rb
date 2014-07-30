describe ActiveMapping::Map do
  describe '#register' do
    let(:map) { ActiveMapping::Map.new }

    it 'should register new mapping' do
      map.register :import

      mapping = map[:import]
      expect(mapping).to be_instance_of ActiveMapping::Mapping
    end
  end
end
