describe ActiveMapping::Node::Object do
  let(:node) { ActiveMapping::Node::Object.new 'key1.key11.key111' }

  describe '#read' do
    it 'should return nil when path is not avaiable' do
      expect(node.read(OpenStruct.new)).to be_nil
      expect(node.read(OpenStruct.new(key1: 1))).to be_nil
      expect(node.read(OpenStruct.new(key1: OpenStruct.new(key11: 1)))).to be_nil
    end

    it 'should read from passed object' do
      obj = OpenStruct.new(key1: OpenStruct.new(key11: OpenStruct.new(key111: 'value')))

      expect(node.read(obj)).to eql 'value'
    end
  end

  describe '#write' do
    let(:obj) { OpenStruct.new(key1: OpenStruct.new(key11: OpenStruct.new(key111: nil))) }

    it 'should write by path' do
      node.write obj, 'value'
      expect(obj.key1.key11.key111).to eql 'value'
    end
  end
end
