describe TwoWayMapper::Node::Hash do
  context 'normal keys' do
    let(:node) { TwoWayMapper::Node::Hash.new 'key1.key11.key111' }

    describe '#read' do
      it 'should return nil when path is not avaiable' do
        expect(node.read({})).to be_nil
        expect(node.read(key1: 1)).to be_nil
        expect(node.read(key1: { key11: 1 })).to be_nil
      end

      it 'should read from passed object' do
        expect(node.read(key1: { key11: { key111: 'value' } })).to eql 'value'
      end
    end

    describe '#write' do
      let(:obj) { {} }

      it 'should write by path' do
        node.write obj, 'value'
        expect(obj).to eql key1: { key11: { key111: 'value' } }
      end
    end
  end

  context 'string keys' do
    let(:node) { TwoWayMapper::Node::Hash.new 'key1.key11.key111', stringify_keys: true }

    describe '#read' do
      it 'should return nil when path is not avaiable' do
        expect(node.read({})).to be_nil
        expect(node.read('key1' => 1)).to be_nil
        expect(node.read('key1' => { 'key11' => 1 })).to be_nil
      end

      it 'should read from passed object' do
        expect(node.read('key1' => { 'key11' => { 'key111' => 'value' } })).to eql 'value'
      end
    end

    describe '#write' do
      let(:obj) { {} }

      it 'should write by path' do
        node.write obj, 'value'
        expect(obj).to eql 'key1' => { 'key11' => { 'key111' => 'value' } }
      end
    end
  end

  context 'write_if option' do
    let(:node) { TwoWayMapper::Node::Hash.new 'key1.key11', write_if: ->(c, n) { c.empty? || n == 'value1' } }
    let(:writable_obj1) { { key1: { key11: '' } } }
    let(:writable_obj2) { { key1: { key11: 'smth' } } }
    let(:not_writable_obj) { { key1: { key11: 'smth' } } }

    it 'should not write if such option passed and it satisfy condition' do
      node.write writable_obj1, 'value'
      node.write writable_obj2, 'value1'
      node.write not_writable_obj, 'value'

      expect(writable_obj1[:key1][:key11]).to eql 'value'
      expect(writable_obj2[:key1][:key11]).to eql 'value1'
      expect(not_writable_obj[:key1][:key11]).not_to eql 'value'
    end
  end
end
