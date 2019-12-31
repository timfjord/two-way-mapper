# frozen_string_literal: true

describe TwoWayMapper::Node::Base do
  describe '#keys' do
    subject { described_class.new('key1.key11.key111') }

    its(:keys) { should eql %i[key1 key11 key111] }
  end

  describe 'writable?' do
    it 'should be truthy if write_if options not set' do
      node = described_class.new('key1.key11.key111')

      expect(node).to be_writable 'current', 'new'
    end

    it 'should be truthy if write_if option set' do
      node = described_class.new(
        'key1.key11.key111',
        write_if: ->(c, n) { c == 'current' || n == 'new' }
      )

      expect(node).to be_writable 'current', 'new1'
      expect(node).to be_writable 'current1', 'new'
      expect(node).not_to be_writable 'current1', 'new1'
    end
  end
end
