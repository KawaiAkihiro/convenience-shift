require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StaffsSessionsHelper. For example:
#
# describe StaffsSessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe StaffsSessionsHelper, type: :helper do
  describe "current_staffに関するテスト" do
    let!(:master) { FactoryBot.create(:master) }
    let!(:staff)  { FactoryBot.create(:staff, master_id: master.id) }
     before do
         log_in_staff(staff)
     end

     example "current_staffは正しいstaffを返してくれるのか" do
         expect(current_staff).to eq (staff)
         expect(is_logged_in_staff?).to be_truthy
     end
  end
end
