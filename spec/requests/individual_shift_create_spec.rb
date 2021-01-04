require 'rails_helper'

RSpec.describe "individual_shift create", type: :request do
    describe "シフト登録" do
        let!(:master) { create(:master_staff) }
        let!(:staff)  { create(:staff, master_id:master.id) }
        before do
            log_in_staff(staff)
        end

        example "昼勤務の仮登録成功(登録)" do
            get new_individual_shift_path
            expect {
                post individual_shifts_path, params: { individual_shift: { start: "2021-01-01 9:00",
                                                                          finish: "10:00:00"},
                                                                          commit: "登録"}
            }.to change(IndividualShift, :count).by(1)
            expect(IndividualShift.first.finish).to eq "2021-01-01 10:00:00"
            expect(IndividualShift.first.confirm).to eq false
            redirect_to staff
            follow_redirect!

            expect(response).to render_template("staffs/show")
            expect(flash).to_not be_empty
        end

        example "夜勤務の登録成功(登録)" do
            get new_individual_shift_path
            expect {
                post individual_shifts_path, params: { individual_shift: { start: "2021-01-01 22:00",
                                                                          finish: "7:00:00"},
                                                                          commit: "登録"}
            }.to change(IndividualShift, :count).by(1)
            expect(IndividualShift.first.finish).to eq "2021-01-02 7:00:00"
            expect(IndividualShift.first.confirm).to eq false
            redirect_to staff
        end

        example "連続する登録成功(もう一度)" do
            get new_individual_shift_path
            expect {
                post individual_shifts_path, params: { individual_shift: { start: "2021-01-01 22:00",
                                                                          finish: "7:00:00"},
                                                                          commit: "もう一度"}
            }.to change(IndividualShift, :count).by(1)
            expect(IndividualShift.first.confirm).to eq false
            redirect_to new_individual_shift_path
            follow_redirect!
            expect(response).to render_template("individual_shifts/new")
            expect(flash).to_not be_empty
        end

        example "時間指定間違いによる登録失敗" do
            get new_individual_shift_path
            expect {
                post individual_shifts_path, params: { individual_shift: { start: "2021-01-01 10:00:00",
                                                                          finish: "7:00:00"},
                                                                          commit: "登録"}
            }.to change(IndividualShift, :count).by(0)
            expect(response).to render_template("individual_shifts/new")
        end

        describe "唯一性確認テスト" do
            let!(:shift1) { create(:shift1, staff_id:staff.id) }
            example "同じ時間は登録不可能" do
                get new_individual_shift_path
                expect {
                    post individual_shifts_path, params: { individual_shift: { start: "2020-12-25 05:00:00",
                                                                              finish: "07:00:00"},
                                                                              commit: "もう一度"}
                }.to change(IndividualShift, :count).by(0)
                expect(response).to render_template("individual_shifts/new")
            end
        end

        
    end

    describe "アクセス制限テスト" do
        before do
            post staffs_logout_path
        end

        example "スタッフログインしていないと新規登録ページに入れない" do
            expect(is_logged_in_staff?).to eq false
            get new_individual_shift_path
            expect(flash).to_not be_empty
            expect(response).to redirect_to staffs_login_url
        end

        example "スタッフログインしていないと新規登録(登録)できない" do
            post individual_shifts_path, params: { individual_shift: { start: "2020-01-01 2:00:00",
                                                                      finish: "4:00:00"},
                                                                      commit: "登録"}
            expect(flash).to_not be_empty
            expect(response).to redirect_to staffs_login_url
        end

        example "スタッフログインしていないと新規登録(もう一度)できない" do
            post individual_shifts_path, params: { individual_shift: { start: "2020-01-01 2:00:00",
                                                                      finish: "4:00:00"},
                                                                      commit: "登録"}
            expect(flash).to_not be_empty
            expect(response).to redirect_to staffs_login_url
        end
    end
end