require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  describe "記憶付きでログイン" do
    let!(:master) { create(:master) }
    before do
      remember(master)
    end

    example "current_masterは正しいmasterを返してくれるのか" do
      expect(current_master).to eq (master)
      expect(is_logged_in?).to be_truthy
    end

    example "current_masterはmasterの記憶ダイジェストが記憶トークンと一致していないの時、nilを返す" do
      master.update_attribute(:remember_digest, Master.digest(Master.new_token))
      expect(current_master).to be_nil
    end
  end

  # describe "current_staffに関するテスト" do
  #   let!(:master) { FactoryBot.create(:master) }
  #   let!(:staff)  { FactoryBot.create(:staff, master_id: master.id) }
  #    before do
  #        log_in_staff(staff)
  #    end

  #    example "current_staffは正しいstaffを返してくれるのか" do
  #        expect(current_staff).to eq (staff)
  #        expect(logged_in_staff?).to be_truthy
  #    end
  # end

end
