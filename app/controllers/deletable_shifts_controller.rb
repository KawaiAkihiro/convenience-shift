class DeletableShiftsController < ApplicationController
    before_action :logged_in_master
    
    def index
        #このページで全てのアクションを実行していく
        @events = current_master.individual_shifts.where(Temporary: false).where(deletable: true)
    end

    #消す予定だったシフトを復活させる用のmodalの中身のhtmlを返す
    def restore
        @event = current_master.individual_shifts.find(params[:shift_id])
        return_html('form_reborn')
    end

    #シフト復活処理
    def reborn
        @event = current_master.individual_shifts.find(params[:id])
        @event.deletable = false
        @event.save
        # 成功処理
    end
end
