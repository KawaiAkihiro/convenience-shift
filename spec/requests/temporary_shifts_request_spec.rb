require 'rails_helper'

RSpec.describe "TemporaryShifts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/temporary_shifts/index"
      expect(response).to have_http_status(:success)
    end
  end

end
