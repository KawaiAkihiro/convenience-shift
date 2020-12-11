class StaffsController < ApplicationController
    def index
        @staffs = current_master.staffs.all
    end

    def show
        @staff  = current_master.staffs.find_by(params[:id])
    end

    def create
        @staff  = current_master.staffs.build(staff_params)
        if @staff.save
            flash[:success] = "従業員登録完了しました"
            #連続でユーザー登録するかしないか確認して、yes-> 新規登録画面　no-> 一覧に戻る
        else
            render 'new'
        end
    end

    def destroy
    end

    private
       def staff_params
        params.require(:staff).permit(:staff_name, :staff_number, :training_mode)
       end
end
