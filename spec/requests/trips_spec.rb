describe "GET /api/v1/trips" do
  it "returns trips" do
    create_list(:trip, 5)
    get "/api/v1/trips"
    expect(response).to have_http_status(:ok)
  end
end
