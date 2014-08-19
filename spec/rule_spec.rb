describe TwoWayMapper::Rule do
  context 'transformation methods' do
    let(:left_node) { TwoWayMapper::Node::Object.new 'key1' }
    let(:right_node) { TwoWayMapper::Node::Hash.new 'Kk.Key1' }
    let(:left_object) { OpenStruct.new }
    let(:map) { { 'value' => 'VALUE' } }

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
      let(:rule) { TwoWayMapper::Rule.new left_node, right_node, map: map, default: 'not found' }

      describe '#from_left_to_right' do
        it 'should read from left node and write to right node' do
          left_object.key1 = 'value'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'VALUE' }
        end
      end

      describe '#from_right_to_left' do
        it 'should read from right node and write to left node' do
          left_object.key1 = nil
          right_object = { Kk: { Key1: 'VALUE' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'value'
        end
      end
    end

    context 'with default option' do
      describe '#from_left_to_right' do
        it 'should return default value if not found' do
          rule = TwoWayMapper::Rule.new left_node, right_node, map: map, default: 'not found'

          left_object.key1 = 'value1'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'not found' }
        end

        it 'should return use default_left if present and value not found' do
          rule = TwoWayMapper::Rule.new left_node, right_node, map: map, default: 'not found', default_left: 'not found on left', default_right: 'not found on right'

          left_object.key1 = 'value1'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'not found on left' }
        end
      end

      describe '#from_right_to_left' do
        it 'should return default value if not found' do
          rule = TwoWayMapper::Rule.new left_node, right_node, map: map, default: 'not found'

          left_object.key1 = nil
          right_object = { Kk: { Key1: 'VALUE1' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'not found'
        end

        it 'should return use default_right if present and value not found' do
          rule = TwoWayMapper::Rule.new left_node, right_node, map: map, default: 'not found', default_left: 'not found on left', default_right: 'not found on right'

          left_object.key1 = nil
          right_object = { Kk: { Key1: 'VALUE1' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'not found on right'
        end
      end
    end

    describe 'with callback option' do
      describe 'on_left_to_right' do
        it 'should transform value if such options passed' do
          rule = TwoWayMapper::Rule.new left_node, right_node, on_left_to_right: ->(v) { v.upcase }

          left_object.key1 = 'value1'
          right_object = {}
          rule.from_left_to_right left_object, right_object

          expect(right_object).to eql Kk: { Key1: 'VALUE1' }
        end
      end

      describe 'on_right_to_left' do
        it 'should transform value if such options passed' do
          rule = TwoWayMapper::Rule.new left_node, right_node, on_right_to_left: ->(v) { v.downcase }

          left_object.key1 = nil
          right_object = { Kk: { Key1: 'VALUE1' } }
          rule.from_right_to_left left_object, right_object

          expect(left_object.key1).to eql 'value1'
        end
      end
    end
  end
end
