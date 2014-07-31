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
end
