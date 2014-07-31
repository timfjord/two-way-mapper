describe ActiveMapping::Node::Abstract do
  describe '#keys' do
    subject { ActiveMapping::Node::Abstract.new 'key1.key11.key111' }

    its(:keys) { should eql [:key1, :key11, :key111] }
  end
end
