describe TwoWayMapper::Rule do
  context 'transformation methods' do
    let(:left_node) { TwoWayMapper::Node::Object.new 'key1' }
    let(:right_node) { TwoWayMapper::Node::Hash.new 'Kk.Key1' }
    let(:left_object) { OpenStruct.new }

    context 'without options' do
      let(:rule) { TwoWayMapper::Rule.new left_node, right_node }

      describe '#from_left_to_right' do
        it 'should read from left node and write to right node' do
          left_object.key1 = 'value1'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'value1' }
        end
      end

      describe '#from_right_to_left' do
        it 'should read from right node and write to left node' do
          left_object.key1 = nil
          right_object = { Kk: { Key1: 'value1' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'value1'
        end
      end
    end

    context 'with map option' do
      let(:map) { { 'value' => 'VALUE' } }
      let(:rule) { TwoWayMapper::Rule.new left_node, right_node, map: map, default: 'not found' }

      describe '#from_left_to_right' do
        it 'should read from left node and write to right node' do
          left_object.key1 = 'value'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'VALUE' }
        end

        it 'should return default value if not found' do
          left_object.key2 = 'value'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'not found' }
        end
      end

      describe '#from_right_to_left' do
        it 'should read from right node and write to left node' do
          left_object.key1 = nil
          right_object = { Kk: { Key1: 'VALUE' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'value'
        end

        it 'should return default value if not found' do
          left_object.key1 = nil
          right_object = { Kk: { Key1: 'VALUE1' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'not found'
        end
      end
    end
  end
end
