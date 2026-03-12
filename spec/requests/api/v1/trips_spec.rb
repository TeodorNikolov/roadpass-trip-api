# spec/requests/api/v1/trips_spec.rb
RSpec.describe 'Trips API', type: :request do
  let!(:trips) { create_list(:trip, 5) }

  describe 'GET /api/v1/trips' do
    before { get '/api/v1/trips' }

    it 'returns trips with pagination metadata' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'].size).to eq(5)
    end
  end

  describe 'POST /api/v1/trips' do
    let(:valid_params) { { trip: { name: 'Test', image_url: 'http://example.com/img.jpg', short_description: 'Short', long_description: 'Long', rating: 4 } } }

    it 'creates a trip' do
      expect { post '/api/v1/trips', params: valid_params }.to change { Trip.count }.by(1)
      expect(response).to have_http_status(:created)
    end
  end
end
