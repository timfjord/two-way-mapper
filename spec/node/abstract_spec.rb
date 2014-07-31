describe TwoWayMapper::Node::Abstract do
  describe '#keys' do
    subject { TwoWayMapper::Node::Abstract.new 'key1.key11.key111' }

    its(:keys) { should eql [:key1, :key11, :key111] }
  end
end
