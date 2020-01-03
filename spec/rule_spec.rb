# frozen_string_literal: true

describe TwoWayMapper::Rule do
  let(:left_node) { TwoWayMapper::Node::Object.new('key1') }
  let(:left_nodes) { [left_node] }
  let(:right_node) { TwoWayMapper::Node::Hash.new('Kk.Key1') }
  let(:right_nodes) { [right_node] }
  let(:left_object) { OpenStruct.new }
  let(:map) { { 'value' => 'VALUE' } }
  let(:options) { {} }
  let(:rule) { described_class.new(left_nodes, right_nodes, options) }

  context 'without options' do
    let(:options) { {} }

    describe '#from_left_to_right' do
      it 'should read from the left node and write to the right node' do
        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'value1' }
      end
    end

    describe '#from_right_to_left' do
      it 'should read from the right node and write to the left node' do
        left_object.key1 = nil
        right_object = { Kk: { Key1: 'value1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value1'
      end
    end
  end

  context 'with from_left_to_right_only/from_right_to_left_only options' do
    describe '#from_left_to_right' do
      let(:options) { { from_right_to_left_only: true } }

      it 'should do nothing if from_right_to_left_only is set to true' do
        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql({})
      end
    end

    describe '#from_right_to_left' do
      let(:options) { { from_left_to_right_only: true } }

      it 'should do nothing if from_left_to_right_only is set to true' do
        left_object.key1 = nil
        right_object = { Kk: { Key1: 'value1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to be_nil
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

  context 'with map and default option' do
    describe '#from_left_to_right' do
      it 'should return default value if not found' do
        rule = described_class.new [left_node], [right_node], map: map, default: 'not found'

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'not found' }
      end

      it 'should return use default_left if present and value not found' do
        rule = described_class.new(
          [left_node],
          [right_node],
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
        rule = described_class.new [left_node], [right_node], map: map, default: 'not found'

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'not found'
      end

      it 'should return use default_right if present and value not found' do
        rule = described_class.new(
          [left_node],
          [right_node],
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

  context 'with callback option' do
    describe '#on_left_to_right' do
      it 'should transform value if such options passed' do
        rule = described_class.new(
          [left_node],
          [right_node],
          on_left_to_right: ->(v, _l, _r, _n) { v.upcase }
        )

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'VALUE1' }
      end

      it 'should pass left object and right object' do
        rule = described_class.new(
          [left_node],
          [right_node],
          on_left_to_right: ->(_v, l, r, n) { "#{l.object_id}-#{r.object_id}-#{n.selector}" }
        )

        left_object.key1 = 'value1'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: "#{left_object.object_id}-#{right_object.object_id}-#{left_node.selector}" }
      end
    end

    describe '#on_right_to_left' do
      it 'should transform value if such options passed' do
        rule = described_class.new(
          [left_node],
          [right_node],
          on_right_to_left: ->(v, _l, _r, _n) { v.downcase }
        )

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value1'
      end

      it 'should pass left object and right object' do
        rule = described_class.new(
          [left_node],
          [right_node],
          on_right_to_left: ->(_v, l, r, n) { "#{l.object_id}-#{r.object_id}-#{n.selector}" }
        )

        left_object.key1 = nil
        right_object = { Kk: { Key1: 'VALUE1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql "#{left_object.object_id}-#{right_object.object_id}-#{right_node.selector}"
      end
    end
  end

  context 'with multiple nodes on the left side' do
    let(:another_left_node) { TwoWayMapper::Node::Object.new('key2') }
    let(:left_nodes) { [left_node, another_left_node] }

    describe '#from_left_to_right' do
      it 'should get first non nil value from left nodes and write to the right node' do
        left_object.key2 = 'value2'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'value2' }
      end
    end

    describe '#from_right_to_left' do
      it 'should read from right node and write to all left nodes' do
        left_object.key1 = nil
        left_object.key2 = nil
        right_object = { Kk: { Key1: 'value1' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value1'
        expect(left_object.key2).to eql 'value1'
      end
    end
  end

  context 'with multiple nodes on the right side' do
    let(:another_right_node) { TwoWayMapper::Node::Hash.new('Kk1.Key') }
    let(:right_nodes) { [right_node, another_right_node] }

    describe '#from_left_to_right' do
      it 'should read from the left node and write to all right nodes' do
        left_object.key1 = 'value'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'value' }, Kk1: { Key: 'value' }
      end
    end

    describe '#from_right_to_left' do
      it 'should get first non nil value from right nodes and write to the left node' do
        left_object.key1 = nil
        right_object = { Kk1: { Key: 'value' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value'
      end
    end
  end

  context 'with multiple nodes on both sides' do
    let(:another_left_node) { TwoWayMapper::Node::Object.new('key2') }
    let(:left_nodes) { [left_node, another_left_node] }
    let(:another_right_node) { TwoWayMapper::Node::Hash.new('Kk1.Key') }
    let(:right_nodes) { [right_node, another_right_node] }

    describe '#from_left_to_right' do
      it 'should get first non nil value from left nodes and write to all right nodes' do
        left_object.key2 = 'value'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'value' }, Kk1: { Key: 'value' }
      end
    end

    describe '#from_right_to_left' do
      it 'should get first non nil value from right nodes and write to all left nodes' do
        left_object.key1 = nil
        left_object.key2 = nil
        right_object = { Kk1: { Key: 'value' } }
        rule.from_right_to_left(left_object, right_object)

        expect(left_object.key1).to eql 'value'
      end
    end
  end

  describe 'multiple nodes with callback' do
    let(:another_left_node) { TwoWayMapper::Node::Object.new('key2') }
    let(:left_nodes) { [left_node, another_left_node] }
    # return false on empty string to emulate a situation when we need to skip blank values
    let(:options) { { on_left_to_right: proc { |v| v != '' && v } } }

    describe '#from_left_to_right' do
      it 'should involve the callback' do
        left_object.key1 = ''
        left_object.key2 = 'value'
        right_object = {}
        rule.from_left_to_right(left_object, right_object)

        expect(right_object).to eql Kk: { Key1: 'value' }
      end
    end
  end
end
