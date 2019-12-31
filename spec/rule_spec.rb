# frozen_string_literal: true

describe TwoWayMapper::Rule do
  let(:left_node) { TwoWayMapper::Node::Object.new('key1') }
  let(:right_node) { TwoWayMapper::Node::Hash.new('Kk.Key1') }
  let(:left_object) { OpenStruct.new }
  let(:map) { { 'value' => 'VALUE' } }
  let(:rule) { described_class.new(left_node, right_node, options) }

  context 'without options' do
    let(:options) { {} }

    describe '#from_left_to_right' do
      it 'should read from left node and write to right node' do
        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'value1' }
      end
    end

    describe '#from_right_to_left' do
      it 'should read from right node and write to left node' do
        left_object.key1 = nil
        right_object = { Kk: { Key1: 'value1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value1'
      end
    end
  end

  context 'with map option' do
    let(:options) { { map: map } }

    describe '#from_left_to_right' do
      it 'should read from left node and write to right node' do
        left_object.key1 = 'value'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'VALUE' }
      end
    end

    describe '#from_right_to_left' do
      it 'should read from right node and write to left node' do
        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value'
      end
    end
  end

  context 'with default option' do
    describe '#from_left_to_right' do
      it 'should return default value if not found' do
        rule = described_class.new left_node, right_node, map: map, default: 'not found'

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'not found' }
      end

      it 'should return use default_left if present and value not found' do
        rule = described_class.new(
          left_node,
          right_node,
          map: map,
          default: 'not found',
          default_left: 'not found on left',
          default_right: 'not found on right'
        )

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'not found on left' }
      end
    end

    describe '#from_right_to_left' do
      it 'should return default value if not found' do
        rule = described_class.new left_node, right_node, map: map, default: 'not found'

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'not found'
      end

      it 'should return use default_right if present and value not found' do
        rule = described_class.new(
          left_node,
          right_node,
          map: map,
          default: 'not found',
          default_left: 'not found on left',
          default_right: 'not found on right'
        )

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'not found on right'
      end
    end
  end

  describe 'with callback option' do
    describe 'on_left_to_right' do
      it 'should transform value if such options passed' do
        rule = described_class.new(
          left_node,
          right_node,
          on_left_to_right: ->(v, _l, _r) { v.upcase }
        )

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'VALUE1' }
      end

      it 'should pass left object and right object' do
        rule = described_class.new(
          left_node,
          right_node,
          on_left_to_right: ->(_v, l, r) { "#{l.object_id}-#{r.object_id}" }
        )

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: "#{left_object.object_id}-#{right_object.object_id}" }
      end
    end

    describe 'on_right_to_left' do
      it 'should transform value if such options passed' do
        rule = described_class.new(
          left_node,
          right_node,
          on_right_to_left: ->(v, _l, _r) { v.downcase }
        )

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value1'
      end

      it 'should pass left object and right object' do
        rule = described_class.new(
          left_node,
          right_node,
          on_right_to_left: ->(_v, l, r) { "#{l.object_id}-#{r.object_id}" }
        )

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql "#{left_object.object_id}-#{right_object.object_id}"
      end
    end
  end
end
