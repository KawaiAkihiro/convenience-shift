class DeletableShiftsController < ApplicationController
    def index
        @events = current_master.individual_shifts.where(Temporary: false).where(deletable: true)
    end

    #消す予定だったシフトを復活させる用のmodalの中身のhtmlを返す
    def restore
        @event = current_master.individual_shifts.find(params[:shift_id])
        render plain: render_to_string(partial: 'form_reborn', layout: false, locals: { event: @event })
    end

    #シフト復活処理
    def reborn
        @event = current_master.individual_shifts.find(params[:id])
        @event.deletable = false
        @event.save
        # 成功処理
    end
end
