# frozen_string_literal: true

describe TwoWayMapper::Map do
  describe '#register' do
    let(:map) { described_class.new }

    it 'should register new mapping' do
      map.register :import

      mapping = map[:import]
      expect(mapping).to be_instance_of TwoWayMapper::Mapping
    end
  end
end
