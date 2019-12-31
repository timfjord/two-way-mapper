# frozen_string_literal: true

describe TwoWayMapper::Tools do
  describe '.first_item_from_hash!' do
    it 'should raise error unless hash passed' do
      expect { described_class.first_item_from_hash! }.to raise_error ArgumentError
      expect { described_class.first_item_from_hash! '' }.to raise_error ArgumentError
      expect { described_class.first_item_from_hash! 1 }.to raise_error ArgumentError
    end

    it 'should raise error if emplt hash passed' do
      expect { described_class.first_item_from_hash! {} }.to raise_error ArgumentError
    end

    it 'should return first hash key and value' do
      k, v = described_class.first_item_from_hash! a: 1

      expect(k).to eql :a
      expect(v).to eql 1
    end

    it 'should delete first item' do
      hash = { a: 1, b: 2 }
      _k, _v = described_class.first_item_from_hash!(hash)

      expect(hash).not_to include a: 1
    end
  end
end
