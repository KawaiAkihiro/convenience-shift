require 'rails_helper'

RSpec.describe "Masters", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/signup"
      expect(response).to have_http_status(:success)
    end
  end

end
