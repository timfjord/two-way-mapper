describe TwoWayMapper::Node::Object do
  let(:node) { TwoWayMapper::Node::Object.new 'key1.key11.key111' }

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

  context 'write_if option' do
    let(:node) { TwoWayMapper::Node::Object.new 'key', write_if: ->(c, n) { c.empty? || n == 'value1'} }
    let(:writable_obj1) { OpenStruct.new key: '' }
    let(:writable_obj2) { OpenStruct.new key: 'smth' }
    let(:not_writable_obj) { OpenStruct.new key: 'smth' }

    it 'should not write if such option passed and it satisfy condition' do
      node.write writable_obj1, 'value'
      node.write writable_obj2, 'value1'
      node.write not_writable_obj, 'value'

      expect(writable_obj1.key).to eql 'value'
      expect(writable_obj2.key).to eql 'value1'
      expect(not_writable_obj.key).not_to eql 'value'
    end
  end
end
