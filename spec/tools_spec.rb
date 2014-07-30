describe ActiveMapping::Tools do
  let(:tools) { ActiveMapping::Tools }

  describe '.first_item_from_hash!' do
    it 'should raise error unless hash passed' do
      expect{tools.first_item_from_hash!}.to raise_error
      expect{tools.first_item_from_hash! ''}.to raise_error
      expect{tools.first_item_from_hash! 1}.to raise_error
    end

    it 'should raise error if emplt hash passed' do
      expect{tools.first_item_from_hash! {}}.to raise_error
    end

    it 'should return first hash key and value' do
      k, v = tools.first_item_from_hash! a: 1

      expect(k).to eql :a
      expect(v).to eql 1
    end

    it 'should delete first item' do
      hash = { a: 1, b: 2 }
      k, v = tools.first_item_from_hash! hash

      expect(hash).not_to include a: 1
    end
  end
end
