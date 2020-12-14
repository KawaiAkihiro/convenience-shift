class StaffsController < ApplicationController
    before_action :corrent_staff,  only: [:show]
    before_action :logged_in_staff, only: [:show]

    def index
        @staffs = current_master.staffs.paginate(page:params[:page])
    end

    def show
        @staff  = current_staff
    end

    def new
        @staff = current_master.staffs.new
    end

    def create
        @staff  = current_master.staffs.new(staff_params)
        if @staff.save
            flash[:success] = "従業員登録完了しました"
            #連続でユーザー登録するかしないか確認して、yes-> 新規登録画面　no-> 一覧に戻る
            redirect_to current_master
        else
            render 'new'
        end
    end

    def edit
        @staff = current_master.staffs.find(params[:id])
    end

    def update
        @staff = current_master.staffs.find(params[:id])
        if @staff.update(staff_params)
            flash[:success] = "従業員情報を変更しました"
            redirect_to staffs_path
        else
            render 'edit'
        end
    end

    def destroy
        current_master.staffs.find(params[:id]).destroy
        flash[:success] = "削除完了しました"
        redirect_to staffs_path
    end

    private
       def staff_params
         params.require(:staff).permit(:staff_name, :staff_number, :password, :password_confirmation, :training_mode)
       end

       
       def logged_in_staff
        unless logged_in_staff?
          flash[:danger] = "ログインしてください"
          redirect_to staffs_login_url
        end
      end

      def corrent_staff
        @master = Master.find(current_staff.master_id)
        @other_staff = @master.staffs.find(params[:id])
        unless current_staff?(@other_staff)
          flash[:danger] = "他のユーザの情報は見ることができません"
          redirect_to(root_url) 
        end
      end 
end
