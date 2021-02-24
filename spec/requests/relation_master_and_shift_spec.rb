require 'rails_helper'

RSpec.describe "relation master and shift", type: :request do
    describe "シフト募集開始、終了に関するテスト"
      let!(:master) { create(:master_staff) }
      let!(:staff)  { create(:staff, master_id: master.id) }
      before do
        log_in_as2(master)
      end

      example "シフト募集がoffのときはstaff側に提出のurlがでない" do
        # expect(master.shift_onoff).to eq false
        # post logout_path
        # expect(is_logged_in?).to eq false
        # log_in_staff(staff)
        # get staff_path(staff)
        # expect(page).to_not have_link "シフト提出"
        # expect(page).to_not have_link "提出したシフトを確認する"
      end

      example "シフト募集がonのときはstaff側に提出のurlが表示される" do
        # expect(master.shift_onoff).to eq false
        # patch shift_onoff_master_path(master)
        # redirect_to master_path(master)
        # follow_redirect!
        # expect(master.reload.shift_onoff).to eq true
        # post logout_path
        # log_in_staff(staff)
        # get staff_path(staff)
        # expect(response.body).to include "シフト提出"
        # expect(response.body).to include "提出したシフトを確認する"
        # # expect(page).to have_link "シフト提出"
        # # expect(page).to have_link "提出したシフトを確認する"
      end
end