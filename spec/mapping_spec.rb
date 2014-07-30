describe ActiveMapping::Mapping do
  describe 'participant classes' do
    subject { ActiveMapping::Mapping.new :object, :hash }

    its(:left_class) { should eql ActiveMapping::Node::Object }
    its(:right_class) { should eql ActiveMapping::Node::Hash }
  end

  describe '#rule' do
    let(:mapping) { ActiveMapping::Mapping.new :object, :hash }
    subject { mapping.rule 'key1', 'Key1' }

    it 'should add item to rules hash' do
      expect{subject}.to change{mapping.rules.count}.from(0).to(1)

      rule = mapping.rules.first
      expect(rule).to be_instance_of ActiveMapping::Rule
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

    context 'options' do
      let(:mapping_with_options) { ActiveMapping::Mapping.new :object, :hash, left_opt: { strngify_keys: true }, right_opt: { strngify_keys: true } }

      it 'should allow left and right options from mapping options' do
        mapping_with_options.rule 'key1', 'Key1'

        rule = mapping_with_options.rules.first
        expect(rule.left.opt).to include strngify_keys: true
        expect(rule.right.opt).to include strngify_keys: true
      end
    end
  end

  context 'convertion methods' do
    let(:mapping) { ActiveMapping::Mapping.new :object, :hash }
    let(:rule1) { double from_left_to_right: nil, from_right_to_left: nil }
    let(:rule2) { double from_left_to_right: nil, from_right_to_left: nil }
    let(:left_obj) { double() }
    let(:right_obj) { double() }
    before :each do
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
