require 'rails_helper'

RSpec.describe "shift_separation edit", type: :request do
    describe "シフトコマ編集に関するテスト" do
        let!(:master){ create(:master_staff) }
        let!(:shift) { create(:morning_fast, master_id: master.id)}
        before do
            log_in_as2(master)
        end

        example "編集成功" do
            get edit_master_shift_separation_path(master,shift)
            expect(response).to render_template("shift_separations/edit")
            patch master_shift_separation_path(master,shift), params: { shift_separation:{ name: "朝",
                                                                                     start_time: "2000-01-01 06:00:00",
                                                                                     finish_time:"2000-01-01 10:00:00"}}
            expect(response).to redirect_to master_shift_separations_path
            follow_redirect!
            expect(flash).to_not be_empty
            shift.reload
            expect(shift.name).to eq "朝"
            expect(shift.start_time).to eq "2000-01-01 06:00:00"
        end

        example "編集失敗" do
            get edit_master_shift_separation_path(master,shift)
            patch master_shift_separation_path(master,shift), params: { shift_separation: { name:"", 
                                                                                      start_time: "",
                                                                                      finish_time: "" }}
            expect(response).to render_template("shift_separations/edit")
            expect(response.body). to include '3 つの記入エラーがありました。'
        end
    end

    describe "アクセス制限テスト" do
        let!(:master){ create(:master_staff) }
        let!(:other_master){ create(:master)}
        let!(:shift) { create(:morning_fast, master_id: master.id)}

        example "ログインしていないと編集フォームに入れない" do
            get edit_master_shift_separation_path(master,shift)
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end

        example "ログインしていないと直接編集できない" do
            patch master_shift_separation_path(master,shift), params: { shift_separation: {name: "test",
                                              start_time:"2000-01-01 01:00:00",
                                             finish_time:"2000-01-01 02:00:00"} }
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end

        example "他のmasterは他のmasterのシフトコマ編集フォームに入れない" do
            log_in_as2(other_master)
            get edit_master_shift_separation_path(master,shift)
            expect(flash).to be_empty
            expect(response).to redirect_to root_url
        end

        example "他のmasterは他のmasterのシフトコマを直接編集できない" do
            log_in_as2(other_master)
            patch master_shift_separation_path(master,shift), params: { shift_separation: {name: "test",
                                              start_time:"2000-01-01 01:00:00",
                                             finish_time:"2000-01-01 02:00:00"} }
            expect(flash).to be_empty
            expect(response).to redirect_to root_url
        end
    end
end