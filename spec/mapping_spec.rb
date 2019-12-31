# frozen_string_literal: true

describe TwoWayMapper::Mapping do
  let(:mapping) { described_class.new }

  described_class::DIRECTIONS.each do |method|
    describe "##{method}" do
      it "should set #{method} with options" do
        mapping.send method, :object, opt1: ''

        expect(mapping.send("#{method}_class")).to eql TwoWayMapper::Node::Object
        expect(mapping.send("#{method}_options")).to include opt1: ''
      end
    end

    context 'selectors' do
      before do
        mapping.left :object
        mapping.right :object

        mapping.rule 'firstname', 'FirstName'
        mapping.rule 'fullname',  'FullName', from_right_to_left_only: true
        mapping.rule 'lastname',  'LastName'
        mapping.rule 'fullname1', 'FullName1', from_left_to_right_only: true
      end

      describe '#left_selectors' do
        it 'should get left selectors' do
          expect(mapping.left_selectors).to eql %w(firstname fullname lastname fullname1)
        end

        it 'should include only mappable selectors if such option is passed' do
          expect(mapping.left_selectors(mappable: true)).to eql %w(firstname fullname lastname)
        end
      end

      describe '#right_selectors' do
        it 'should get right selectors' do
          expect(mapping.right_selectors).to eql %w(FirstName FullName LastName FullName1)
        end

        it 'should include only mappable selectors if such option is passed' do
          expect(mapping.right_selectors(mappable: true)).to eql %w(FirstName LastName FullName1)
        end
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
      expect(rule.left.selector).to eql 'key1'
      expect(rule.right.selector).to eql 'Key1'
    end

    it 'should allow to pass hash' do
      expect { mapping.rule 'key1' => { opt1: 'val' } }.to raise_error StandardError

      mapping.rule 'key1' => { opt1: 'val' }, 'Key2' => {}
      rule = mapping.rules.first

      expect(rule.left.selector).to eql 'key1'
      expect(rule.right.selector).to eql 'Key2'
    end

    it 'should allow to pass left abd right options ' do
      mapping.rule 'key1', 'Key2', left: { opt1: 'val' }, right: { opt2: 'val' }
      rule = mapping.rules.first

      expect(rule.left.options).to include opt1: 'val'
      expect(rule.right.options).to include opt2: 'val'
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

    [:from_left_to_right, :from_right_to_left].each do |method|
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
