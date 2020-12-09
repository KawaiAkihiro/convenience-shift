require "rails_helper"

RSpec.describe "Masters signup", type: :request do
    example "完全な情報による登録" do
        get signup_path
        expect {
            post masters_path, params: { master: { store_name: "Example Store",
                                                 user_name: "Example user",
                                                 password:              "foobar",
                                                 password_confirmation: "foobar"} }                             
        }.to change(Master, :count).by(1)
        redirect_to @master
        follow_redirect!

        expect(response).to render_template('masters/show')
        expect(flash).to_not be_empty
        expect(is_logged_in?).to be_truthy
    end

    example "不完全な情報による登録" do
        get signup_path
        expect {
            post masters_path, params: { master: { store_name: "Example Store",
                                                   user_name: "",
                                                   password:              "foobaz",
                                                   password_confirmation: "foobar"} } 
        }.to change(Master, :count).by(0)
        expect(response).to render_template('masters/new')
        expect(response.body).to include '2 つの記入エラーがありました。'
    end

end