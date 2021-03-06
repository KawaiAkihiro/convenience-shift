require "rails_helper"

RSpec.describe "Staffs signup", type: :request do
    describe "従業員登録" do
        let!(:master){ create(:master) }
        before do
          log_in_as2(master, remember_me:'0')
        end
        example "完全な情報による従業員登録" do
          # get new_staff_path
          # expect {
          #    post staffs_path, params: { staff: { staff_name: "kawai",
          #                                      staff_number: 145,
          #                                      password:     "0000",
          #                                      password_confirmation: "0000"} }
          # }.to change(Staff, :count).by(1)
          # redirect_to @master
          # follow_redirect!

          # expect(response).to render_template("masters/show")
          # expect(flash).to_not be_empty
          # expect(is_logged_in_staff?).to_not be_truthy
        end

        example "不完全な情報による従業員登録" do
            get new_staff_path
            expect {
                post staffs_path, params: {staff: { staff_name: "",
                                                  staff_number: 1, 
                                                  password: "000",
                                                  password_confirmation: "000"}}                   
            }.to change(Staff, :count).by(0)
            expect(response).to render_template("staffs/new")
            expect(response.body).to include '2 つの記入エラーがありました。'
        end
    end

    describe "スタッフ作成、全体表示のアクセス制限" do
      let!(:master){ create(:master) }

      example "ログインしてない状態で新規staff登録フォーム入れない" do
        get new_staff_path
        expect(flash).to_not be_empty
        expect(response).to redirect_to login_url
      end

      example "ログインしてないと直接スタッフ作成できない" do
        post staffs_path, params: { staff: { staff_name: "kawai",
                                               staff_number: 145,
                                               password:     "0000",
                                               password_confirmation: "0000"} }
        expect(flash).to_not be_empty
        expect(response).to redirect_to login_url
      end

      example "ログインしてないと従業員一覧ページを開けない" do
        get staffs_path
        expect(flash).to_not be_empty
        expect(response).to redirect_to login_url
      end
    end
end