require "rails_helper"

RSpec.describe "Staffs login", type: :request do
    let!(:master) { create(:master_staff) }
    let!(:staff)  { create(:staff, master_id: master.id) }

    example "ログイン失敗" do
        get  staffs_login_path
        post staffs_login_path, params: { staffs_session: {store_name:"stora",
                                                          staff_number: 145,
                                                          password: "0000"}}
        expect(response).to render_template('staffs_sessions/new')
        expect(flash).to_not be_empty
        expect(response.body).to include '店舗名が間違っています'
        get staffs_login_path
        expect(flash).to be_empty
        post staffs_login_path, params: { staffs_session: {store_name:"store",
                                                         staff_number: 145,
                                                         password:"0001"}}
        expect(response).to render_template('staffs_sessions/new')  
        expect(flash).to_not be_empty
        expect(response.body).to include '従業員番号もしくはパスワードが間違っています'
        expect(is_logged_in_staff?).to_not be_truthy
    end

    example "ログイン成功" do
        get staffs_login_path
        post staffs_login_path, params: { staffs_session: { store_name: "store",
                                                          staff_number: 145,
                                                          password:"0000"}}
        expect(is_logged_in_staff?).to be_truthy
        follow_redirect!
        expect(response).to render_template('staffs/show')
        post staffs_logout_path
        expect(is_logged_in_staff?).to_not be_truthy
        expect(response).to redirect_to staffs_login_path
        follow_redirect!
        expect(response).to render_template("staffs_sessions/new")
    end
end