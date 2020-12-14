class StaffsSessionsController < ApplicationController
    def new
    end

    #店名で店長を抽出
    def create
        @master = Master.find_by(store_name: params[:staffs_session][:store_name])
        if @master.nil?
            flash.now[:danger] = '店舗名が間違っています'
            render 'new'
        end
        @staff  = @master.staffs.find_by(staff_number: params[:staffs_session][:staff_number])  
        if @staff && @staff.authenticate(params[:staffs_session][:password])
          log_in_staff @staff
          #params[:session][:remember_me] == '1' ? remember(staff): forget(staff)
          redirect_to @staff
        else
          flash.now[:danger] = "従業員番号もしくはパスワードが間違っています"
          render 'new'
        end
    end

    def destroy
        log_out_staff if logged_in_staff?
        redirect_to staffs_login_url
    end
end
