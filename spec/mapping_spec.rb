describe TwoWayMapper::Mapping do
  [:left, :right].each do |method|
    describe "##{method}" do
      let(:mapping) { TwoWayMapper::Mapping.new }

      it "should set #{method} with options" do
        mapping.send method, :object, opt1: ''

        expect(mapping.send("#{method}_class")).to eql TwoWayMapper::Node::Object
        expect(mapping.send("#{method}_options")).to include opt1: ''
      end
    end
  end

  describe '#rule' do
    let(:mapping) { TwoWayMapper::Mapping.new }
    before :each do
      mapping.left :object
      mapping.right :hash
    end

    context 'left and right validation' do
      let(:mapping_without_both) { TwoWayMapper::Mapping.new }
      let(:mapping_without_left) { TwoWayMapper::Mapping.new }
      let(:mapping_without_right) { TwoWayMapper::Mapping.new }
      before :each do
        mapping_without_left.right :hash
        mapping_without_right.left :hash
      end

      it 'should raise error when no left or right nodes' do
        expect{mapping_without_left.rule 'key', 'key'}.to raise_error
        expect{mapping_without_right.rule 'key', 'key'}.to raise_error
        expect{mapping_without_both.rule 'key', 'key'}.to raise_error
      end
    end

    it 'should add item to rules hash' do
      expect{mapping.rule 'key1', 'Key1'}.to change{mapping.rules.count}.from(0).to(1)

      rule = mapping.rules.first
      expect(rule).to be_instance_of TwoWayMapper::Rule
      expect(rule.left.selector).to eql 'key1'
      expect(rule.right.selector).to eql 'Key1'
    end

    it 'should allow to pass hash' do
      expect{mapping.rule 'key1' => { opt1: 'val' }}.to raise_error

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
    let(:mapping) { TwoWayMapper::Mapping.new }
    let(:rule1) { double from_left_to_right: nil, from_right_to_left: nil }
    let(:rule2) { double from_left_to_right: nil, from_right_to_left: nil }
    let(:left_obj) { double() }
    let(:right_obj) { double() }
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
