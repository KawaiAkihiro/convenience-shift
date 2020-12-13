class StaffsController < ApplicationController
    def index
        @staffs = current_master.staffs.paginate(page:params[:page])
    end

    def show
        @staff  = current_master.staffs.find(params[:id])
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
        params.require(:staff).permit(:staff_name, :staff_number, :training_mode)
       end
end
