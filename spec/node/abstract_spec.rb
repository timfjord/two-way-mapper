describe TwoWayMapper::Node::Abstract do
  describe '#keys' do
    subject { TwoWayMapper::Node::Abstract.new 'key1.key11.key111' }

    its(:keys) { should eql [:key1, :key11, :key111] }
  end

  describe 'writable?' do
    it 'should be truthy if write_if options not set' do
      node = TwoWayMapper::Node::Abstract.new 'key1.key11.key111'

      expect(node).to be_writable 'value'
    end

    it 'should be truthy if write_if option set' do
      node = TwoWayMapper::Node::Abstract.new 'key1.key11.key111', write_if: ->(v) { v == 'value' }

      expect(node).to be_writable 'value'
      expect(node).not_to be_writable 'value1'
    end
  end
end
