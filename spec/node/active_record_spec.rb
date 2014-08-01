describe TwoWayMapper::Node::ActiveRecord do
  let(:node) { TwoWayMapper::Node::ActiveRecord.new 'user.email' }

  describe '#write' do
    it 'should try to build before write' do
      user = double(email: '')
      obj = double()
      allow(obj).to receive :build_user do
        allow(obj).to receive(:user).and_return user
      end

      expect(obj).to receive :build_user
      expect(user).to receive(:email=).with 'test@email.com'

      node.write obj, 'test@email.com'
    end

    it 'should try to build even if respond_to but obj itself is nil' do
      user = double(email: '')
      obj = double(user: nil)
      allow(obj).to receive :build_user do
        allow(obj).to receive(:user).and_return user
      end

      expect(obj).to receive :build_user
      expect(user).to receive(:email=).with 'test@email.com'

      node.write obj, 'test@email.com'
    end
  end
end
