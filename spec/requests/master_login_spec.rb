require 'rails_helper'

RSpec.describe "Master login", type: :request do

  example "不正確なログイン" do
    get login_path
    post login_path, params: { session: { store_name:"", password:""}}
    expect(is_logged_in?).to_not be_truthy
    expect(response).to render_template('sessions/new')
    expect(flash).to_not be_empty
    get root_path
    expect(flash).to be_empty
  end

  describe 'ログイン確認' do
    let!(:master) { create(:master) }
    example "正確なログインとログアウト" do
      get login_path
      post login_path, params: {session: { store_name: master.store_name, password: master.password}}
      expect(response).to redirect_to master_path(master)
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(response).to render_template('masters/show')
      delete logout_path
      expect(is_logged_in?).to_not be_truthy
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end

    example "記憶付きのログイン" do
      log_in_as2(master, remember_me:'1')
      expect(cookies[:remember_token]).to_not be_empty
    end

    example "記憶なしのログイン" do
      log_in_as2(master, remember_me:'1')
      delete logout_path
      log_in_as2(master, remember_me:'0')
      expect(cookies[:remember_token]).to be_empty
    end
  end

end