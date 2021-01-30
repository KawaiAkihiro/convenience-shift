require 'rails_helper'

RSpec.describe "ComfirmedShifts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/comfirmed_shifts/index"
      expect(response).to have_http_status(:success)
    end
  end

end
