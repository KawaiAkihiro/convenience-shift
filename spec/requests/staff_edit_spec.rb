require 'rails_helper'

RSpec.describe "staff edit", type: :request do
    describe "店長が一人の従業員に関しての情報編集" do
        let!(:master) { create(:master) }
        let!(:staff)  { create(:staff, master_id: master.id)}
        before do
            log_in_as2(master)
        end
        
        example "編集失敗" do
            get edit_staff_path(staff)
            expect(response).to render_template("staffs/edit")
            patch staff_path(staff), params: { staff: { staff_name: " ",
                                                          staff_number: 1,
                                                          password: "1111",
                                                          password_confirmation: "111",
                                                          training_mode: true}}
            expect(response).to render_template("staffs/edit")
        end
        
        example "編集成功" do
            get edit_staff_path(staff)
            expect(response).to render_template("staffs/edit")
            patch staff_path(staff), params: { staff: { staff_name: "河合彰紘",
                                                        staff_number: 145,
                                                        password: "",
                                                        password_confirmation: "",
                                                        training_mode: true}}
            expect(response).to redirect_to staffs_path
            expect(flash).to_not be_empty
            staff.reload
            expect(staff.training_mode).to eq true
        end
    end

    describe "店員側が自分の情報を編集する" do
        let!(:master) { create(:master_staff)}
        let!(:staff)  { create(:staff, master_id: master.id)}
        before do
           log_in_staff(staff)
        end

        example "編集失敗" do
            get edit_staff_path(staff)
            expect(response).to render_template("staffs/edit")
            expect(response.body).to_not include "トレーニング"
            patch staff_path(staff), params: { staff: { staff_name: " ",
                                                        staff_number: nil,
                                                        password: "000",
                                                        password_confirmation: "000"}}
            expect(response).to render_template("staffs/edit")                                           
        end

        example "編集成功" do
            get edit_staff_path(staff)
            expect(response).to render_template('staffs/edit')
            patch staff_path(staff), params: {staff: {staff_name: "川合彰紘",
                                                      staff_number: 145,
                                                      password: "",
                                                      password_confirmation: ""}}
            expect(response).to redirect_to staff
            follow_redirect!
            expect(response).to render_template("staffs/show")
            staff.reload
            expect(staff.staff_name).to eq "川合彰紘"
        end
    end

    describe "他ユーザの編集権限テスト" do
        let!(:master){ create(:master_staff) }
        let!(:other_master){ create(:master_staff) }
        let!(:staff) { create(:staff, master_id: master.id)}
        let!(:other_staff){ create(:leader, master_id: master.id)}

        example "ログインしてないと編集フォームに入れない" do
            get edit_staff_path(staff)
            expect(flash).to_not be_empty
            expect(response).to redirect_to staffs_login_url
        end

        example "ログインしていないと直接編集できない" do
            patch staff_path(staff), params: { staff: { staff_name: "kawai",
                                                      staff_number: 145,
                                                      password:"",
                                                      password_confirmation:"" }}
            expect(flash).to_not be_empty
            expect(response).to redirect_to staffs_login_url                                         
        end

        example "他の従業員は編集フォームにはいれない" do
            log_in_staff(other_staff)
            get edit_staff_path(staff)
            expect(flash).to_not be_empty
            expect(response).to redirect_to other_staff
        end

        example "他の従業員は直接編集できない" do
            log_in_staff(other_staff)
            patch staff_path(staff), params: { staff: { staff_name: "kawai",
                                                       staff_number: 145,
                                                       password:"",
                                                       password_confirmation:"" }} 
            expect(flash).to_not be_empty
            expect(response).to redirect_to other_staff                                    
        end

        before do
            log_in_as2(other_master)
        end

        exapmle "masterは他のmasterのstaffの個人ページを開けない" do
            get staff
            expect(response).to redirect_to root_url
        end

        example "masterは他のmasterのstaffの編集フォームには入れない" do
            get edit_staff_path(staff)
            expect(response).to redirect_to root_url
        end

        example "masterは他のmasterのstaffを直接編集できない" do
            patch staff_path(staff), params: { staff: { staff_name: "kawai",
                                                       staff_number: 145,
                                                       password:"",
                                                       password_confirmation:"" }} 
            expect(response).to redirect_to root_url
        end

        
    end
end
            