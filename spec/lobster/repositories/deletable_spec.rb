RSpec.describe Deletable do
  let(:users) { UserRepository.new }
  let(:user)  { Factory.create(:user, role: 'admin') }

  let(:attachments) { AttachmentRepository.new }

  let!(:visible_attachment) do
    Factory.create(:attachment, uploaded_by: user.id)
  end

  let!(:invisible_attachment) do
    Factory.create(:attachment, uploaded_by: user.id, visible: false)
  end

  after do
    attachments.clear
    users.clear
  end

  describe '#find_visible' do
    context 'with a visible resource' do
      it 'returns the resource' do
        visible_resource = attachments.find_visible(visible_attachment.id)
        expect(visible_resource).to be_a(Attachment)
      end
    end

    context 'with a deleted resource' do
      it 'returns nil' do
        expect(attachments.find_visible(invisible_attachment.id)).to be_nil
      end
    end
  end

  describe '#only_visible' do
    it 'returns all visible resources' do
      result = attachments.only_visible.to_a
      expect(result).to include(visible_attachment)
    end

    it "doesn't return invisible resources" do
      result = attachments.only_visible.to_a
      expect(result).not_to include(invisible_attachment)
    end
  end
end
