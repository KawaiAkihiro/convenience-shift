require 'rails_helper'

RSpec.describe "Master login", type: :request do

  example "不正確なログイン" do
    get login_path
    post login_path, params: { session: { store_name:"", password:""}}
    expect(response).to render_template('sessions/new')
    expect(flash).to_not be_empty
    get root_path
    expect(flash).to be_empty
  end

  describe 'ログイン確認' do
    let!(:master) { create(:master) }
    example "正確なログイン" do
      get login_path
      post login_path, params: {session: { store_name: master.store_name, password: master.password}}
      expect(response).to redirect_to master_path(master)
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(response).to render_template('masters/show')
    end
  end

end