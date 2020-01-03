# frozen_string_literal: true

describe TwoWayMapper::Mapping do
  let(:mapping) { described_class.new }

  described_class::DIRECTIONS.each do |direction|
    describe "##{direction}" do
      it "should set #{direction} with options" do
        mapping.send direction, :object, opt1: ''

        expect(mapping.send("#{direction}_class")).to eql TwoWayMapper::Node::Object
        expect(mapping.send("#{direction}_options")).to include opt1: ''
      end
    end
  end

  context 'selectors' do
    before do
      mapping.left :object
      mapping.right :object
    end

    before do
      mapping.rule 'firstname', 'FirstName'
      mapping.rule 'fullname',  'FullName', from_right_to_left_only: true
      mapping.rule 'lastname',  'LastName'
      mapping.rule 'fullname1', 'FullName1', from_left_to_right_only: true
      mapping.rule ['field1', 'field2'], 'Field1'
      mapping.rule 'field3', ['Field2', 'Field3']
      mapping.rule ['field4', 'field5'], ['Field4', 'Field5']
    end

    describe '#left_selectors' do
      it 'should get left selectors' do
        expect(mapping.left_selectors).to eql(
          %w(firstname fullname lastname fullname1 field1 field2 field3 field4 field5)
        )
      end

      it 'should include only mappable selectors if such option is passed' do
        expect(mapping.left_selectors(mappable: true)).to eql(
          %w(firstname fullname lastname field1 field2 field3 field4 field5)
        )
      end
    end

    describe '#right_selectors' do
      it 'should get right selectors' do
        expect(mapping.right_selectors).to eql(
          %w(FirstName FullName LastName FullName1 Field1 Field2 Field3 Field4 Field5)
        )
      end

      it 'should include only mappable selectors if such option is passed' do
        expect(mapping.right_selectors(mappable: true)).to eql(
          %w(FirstName LastName FullName1 Field1 Field2 Field3 Field4 Field5)
        )
      end
    end
  end

  describe '#rule' do
    before :each do
      mapping.left :object
      mapping.right :hash
    end

    context 'left and right validation' do
      let(:mapping_without_both) { described_class.new }
      let(:mapping_without_left) { described_class.new }
      let(:mapping_without_right) { described_class.new }

      before :each do
        mapping_without_left.right :hash
        mapping_without_right.left :hash
      end

      it 'should raise error when no left or right nodes' do
        expect { mapping_without_left.rule 'key', 'key' }.to raise_error StandardError
        expect { mapping_without_right.rule 'key', 'key' }.to raise_error StandardError
        expect { mapping_without_both.rule 'key', 'key' }.to raise_error StandardError
      end
    end

    it 'should add item to rules hash' do
      expect { mapping.rule 'key1', 'Key1' }.to change { mapping.rules.count }.from(0).to(1)

      rule = mapping.rules.first
      expect(rule).to be_instance_of TwoWayMapper::Rule
      expect(rule.left_nodes.map(&:selector)).to eql ['key1']
      expect(rule.right_nodes.map(&:selector)).to eql ['Key1']
    end

    it 'should support multiple selectors' do
      mapping.rule ['key1', 'key2'], ['Key1', 'Key2']

      rule = mapping.rules.first

      expect(rule.left_nodes.size).to eql 2
      expect(rule.left_nodes[0].selector).to eql 'key1'
      expect(rule.left_nodes[1].selector).to eql 'key2'
      expect(rule.right_nodes.size).to eql 2
      expect(rule.right_nodes[0].selector).to eql 'Key1'
      expect(rule.right_nodes[1].selector).to eql 'Key2'
    end

    it 'should allow to pass hash' do
      expect { mapping.rule 'key1' => { opt1: 'val' } }.to raise_error StandardError

      mapping.rule 'key1' => { opt1: 'val' }, 'Key2' => {}
      rule = mapping.rules.first

      expect(rule.left_nodes.map(&:selector)).to eql ['key1']
      expect(rule.right_nodes.map(&:selector)).to eql ['Key2']
    end

    it 'should allow to pass left abd right options ' do
      mapping.rule 'key1', 'Key2', left: { opt1: 'val' }, right: { opt2: 'val' }
      rule = mapping.rules.first

      expect(rule.left_nodes.first.options).to include opt1: 'val'
      expect(rule.right_nodes.first.options).to include opt2: 'val'
    end

    it 'should work with options copy' do
      options = { left: { opt1: 'val' }, right: { opt2: 'val' } }
      mapping.rule 'key1', 'Key2', options

      expect(options).to eql left: { opt1: 'val' }, right: { opt2: 'val' }
    end
  end

  context 'convertion methods' do
    let(:rule1) { double from_left_to_right: nil, from_right_to_left: nil }
    let(:rule2) { double from_left_to_right: nil, from_right_to_left: nil }
    let(:left_obj) { double }
    let(:right_obj) { double }

    before :each do
      mapping.left :object
      mapping.right :hash
      allow(mapping).to receive(:rules).and_return [rule1, rule2]
    end

    [described_class::DIRECTIONS, described_class::DIRECTIONS.reverse].each do |from, to|
      method = "from_#{from}_to_#{to}"

      describe "##{method}" do
        it 'should proxy to all rules' do
          expect(rule1).to receive(method).with left_obj, right_obj
          expect(rule2).to receive(method).with left_obj, right_obj

          mapping.send method, left_obj, right_obj
        end
      end
    end
  end
end
