require 'rails_helper'

RSpec.describe "Master edit", type: :request do

    describe "一人のユーザーの情報変更" do
        let!(:master) { create(:master) }
        let!(:master2){ create(:master2) }
        
        example "変更失敗" do
            log_in_as2(master)
            get edit_master_path(master)
            expect(response).to render_template("masters/edit")
            patch master_path(master), params: { master: { store_name: "Example Store",
                                                           user_name: "",
                                                           password:              "foobaz",
                                                           password_confirmation: "foobar" } } 
            expect(response).to render_template("masters/edit")
        end 
        
        example "変更成功" do
            # log_in_as2(master)
            # get edit_master_path(master)
            # expect(response).to render_template("masters/edit")
            # patch master_path(master), params: { master: { store_name: "store_name",
            #                                                user_name:  "user_name",
            #                                                password: "",
            #                                                password_confirmation: "" }}
            # expect(flash).to_not be_empty
            # expect(response).to redirect_to master_path(master)
            # master.reload
            # expect(master.store_name).to eq "store_name"
            # expect(master.user_name).to eq  "user_name"
        end

        example "ログインしていないと編集フォームに入れない" do
            get edit_master_path(master)
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end

        example "ログインしていないと直接編集はできない" do
            patch master_path(master), params: { master: {store_name: master.store_name,
                                                           user_name: master.user_name} }
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end 
        
        example "他のユーザーは編集フォームに入れない" do
            log_in_as2(master2)
            get edit_master_path(master)
            expect(flash).to be_empty
            expect(response).to  redirect_to root_url
        end

        example "他のユーザーは直接編集できない" do
            log_in_as2(master2)
            patch master_path(master), params: { master: { store_name: master.store_name,
                                                            user_name: master.user_name}}
            expect(flash).to be_empty
            expect(response).to redirect_to root_url
        end                                                
    end  
    
end