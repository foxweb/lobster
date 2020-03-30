RSpec.describe Api::Controllers::Images::Upload, type: :action do
  let(:action) { described_class.new }
  let(:object) { instance_double('CreateImage object') }
  let(:result) { instance_double('CreateImage result') }

  before do
    allow(CreateImage).to receive(:new).and_return(object)
    allow(object).to receive(:call).and_return(result)
    # allow(object).to receive(:duplicate).and_return(nil)
    allow(result).to receive(:uploaded_file).and_return(an_instance_of(Hash))
  end

  context 'with valid params' do
    before do
      allow(result).to receive(:success?).and_return(true)
    end

    let(:params) do
      {
        filename:     'image.jpg',
        content_type: 'image/jpeg',
        temp_path:    './spec/fixtures/image.jpg'
      }
    end

    it 'renders 201 Created' do
      expect(response.status).to eq(201)
    end
  end

  context 'with invalid params' do
    let(:params) do
      {
        filename:     'image.jpg',
        content_type: 'image/jpeg',
        temp_path:    ''
      }
    end

    it 'renders 422 Unprocessable Entity status' do
      expect(response.status).to eq(422)
    end

    it 'renders errors' do
      expect(response_body).to eq(temp_path: ['must be filled'])
    end
  end

  context 'with a user without permissions' do
    let(:params) do
      {
        filename:     '3rd-september.jpg',
        content_type: 'image/jpeg',
        temp_path:    './spec/fixtures/image.jpg'
      }
    end

    let(:user_role) { :support }

    it 'renders status 403' do
      expect(response.status).to eq(403)
    end

    it 'renders body Forbidden' do
      expect(response_body).to eq(status: 'Forbidden')
    end
  end
end
