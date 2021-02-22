require 'rails_helper'

RSpec.describe "individual shift confirm", type: :request do
    describe "シフト募集開始、終了に関するテスト" do
        # let!(:master) { create(:master_staff) }
        # let!(:staff)  { create(:staff, master_id: master.id) }
        # let!(:shift1) { create(:shift1, staff_id: staff.id) }
        # let!(:shift3) { create(:shift3, staff_id: staff.id, confirm:true) }

        before do
            # log_in_staff(staff)
        end

        example "シフトの初期状態確認" do
            # expect(shift1.confirm).to eq false
            # expect(shift3.confirm).to eq true
        end

        example "仮提出のシフトを確定する" do
            # get new_individual_shift_path
            # expect(response.body).to include shift1.start.strftime("%Y-%m-%d %H:%M")
            # expect(response.body).to_not include shift3.start.strftime("%Y-%m-%d %H:%M")
            # get confirm_individual_shifts_path
            # expect(response).to render_template("individual_shifts/confirm_form")
            # patch confirm_individual_shifts_path
            # redirect_to staff_path(staff)
            # follow_redirect!
            # expect(shift1.reload.confirm).to be_truthy
            # get confirmed_individual_shifts_path
            # expect(response.body).to include shift1.start.strftime("%Y-%m-%d %H:%M")
            # expect(response.body).to include shift3.start.strftime("%Y-%m-%d %H:%M")
        end
    end
end