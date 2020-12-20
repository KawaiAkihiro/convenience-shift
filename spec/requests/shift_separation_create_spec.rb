require 'rails_helper'

RSpec.describe "shift_separation create", type: :request do
    describe "シフトコマ登録" do
        let!(:master){ create(:master) }
        before do
            log_in_as2(master, remember_me:'0')
        end

        example "有効な情報で作成成功" do
            get new_master_shift_separation_path(master)
            expect(response).to render_template("shift_separations/new")
            expect{
                post master_shift_separations_path, params: { shift_separation: { name: "早朝",
                                                                                  start_time: "2000-01-01 07:00:00",
                                                                                  finish_time:"2000-01-01 10:00:00"} }
            }.to change(master.shift_separations, :count).by(1)
            redirect_to @master
            follow_redirect!

            expect(response).to render_template("masters/show")
            expect(flash).to_not be_empty
        end

        example "記入漏れで作成失敗" do
            get new_master_shift_separation_path(master)
            expect{
                post master_shift_separations_path, params: { shift_separation: { name: "",
                                                                                  start_time: "2000-01-01 09:00:00",
                                                                                  finish_time: ""} }
            }.to change(master.shift_separations, :count).by(0)
            expect(response).to render_template("shift_separations/new")
            expect(response.body).to include '2 つの記入エラーがありました。'
        end

        example "時間の設定ミスで作成失敗" do
            get new_master_shift_separation_path(master)
            expect{
                post master_shift_separations_path, params: { shift_separation: { name: "test",
                                                                                  start_time: "2000-01-01 09:00:00",
                                                                                  finish_time:"2000-01-01 07:00:00"} }
            }.to change(master.shift_separations, :count).by(0)
            expect(response).to render_template("shift_separations/new")
            expect(response.body).to include "終了時刻が開始時刻を上回っています。正しく記入してください。"
        end

        example "深夜帯の設定はできる" do
            get new_master_shift_separation_path(master)
            expect{
                post master_shift_separations_path, params: { shift_separation: { name: "test",
                                                                                  start_time: "2000-01-01 22:00:00",
                                                                                  finish_time:"2000-01-01 07:00:00"}}
            }.to change(master.shift_separations, :count).by(1)
            redirect_to @master
            follow_redirect!

            expect(response).to render_template("masters/show")
            expect(flash).to_not be_empty
        end
    end

    describe "新規登録のアクセス制限テスト" do
        let!(:master){ create(:master_staff) }
        let!(:other_master){ create(:master) }
        
        example "ログインせずに新規作成はできない" do
            get new_master_shift_separation_path(master)
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end

        example "ログインせずに直接作成はできない" do
            post master_shift_separations_path(master), 
               params: { shift_separation: { name: "test",
                                       start_time: "2000-01-01 03:00:00",
                                       finish_time:"2000-01-01 04:00:00"} }
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end

        example "他のmasterのシフトコマ作成画面に入れない" do
            log_in_as2(other_master)
            get new_master_shift_separation_path(master)
            #expect(flash).to_not be_empty
            expect(response).to redirect_to root_url
        end

        example "他のmasterのシフトコマを直接作成できない" do
            log_in_as2(other_master)
            post master_shift_separations_path(master), 
               params: { shift_separation: { name: "test",
                                       start_time: "2000-01-01 03:00:00",
                                       finish_time:"2000-01-01 04:00:00"} }
            #expect(flash).to_not be_empty
            expect(response).to redirect_to root_url
        end

        example "ログインせずに全体画面は表示できない" do
            get master_shift_separations_path(master)
            expect(flash).to_not be_empty
            expect(response).to redirect_to login_url
        end

        example "他のmasterの全体画面は表示できない" do
            log_in_as2(other_master)
            get master_shift_separations_path(master)
            #expect(flash).to_not be_empty
            expect(response).to redirect_to root_url
        end
    end
end