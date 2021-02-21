class TemporaryShiftsController < ApplicationController

  def index
    #このページで全てのアクションを実行していく
    @events = current_master.individual_shifts.where(Temporary: false).where(deletable: false)
  end
  
  def new_shift
    @event = current_master.individual_shifts.new
    @separations = current_master.shift_separations.all
    #空きシフト追加modal用のhtmlを返す
    render plain: render_to_string(partial: 'form_new_shift', layout: false, locals: { event: @event, separations:@separations })
  end

  def new_plan
    @event = current_master.individual_shifts.new
    #終日予定追加modal用のhtmlを返す
    render plain: render_to_string(partial: 'form_new_plan', layout: false, locals: { event: @event })
  end

  #空きシフトを追加する
  def create_shift
    @event = current_master.individual_shifts.new(params_shift)
    @event.staff = current_master.staffs.find_by(staff_number: 0)
    change_finishDate
    if @event.save
      respond_to do |format|
        format.html { redirect_to temporary_shifts_path }
        format.js
      end
    else
      respond_to do |format|
        format.js {render partial: "error" }
      end
    end
  end

  #終日の予定を追加する
  def create_plan
    @event = current_master.individual_shifts.new(params_plan)
    @event.staff = current_master.staffs.find_by(staff_number: 0)
    if @event.save
      respond_to do |format|
        format.html { redirect_to temporary_shifts_path }
        format.js
      end
    end
  end

  def delete
    begin
      @event = current_master.individual_shifts.find(params[:shift_id])
      #削除するmodalのhtmlを返す
      render plain: render_to_string(partial: 'form_deletable', layout: false, locals: { event: @event })
    rescue => exception
      #何もしない(祝日イベント対策)
    end
  end

  #シフト仮削除
  def deletable
    @event = current_master.individual_shifts.find(params[:id])
    #終日の予定なら削除
    if @event.allDay == true
      @event.destroy
    else
      #空きシフトは削除、それ以外は復活可能
      if @event.staff.staff_number != 0
        @event.deletable = true
        @event.save
      else
        @event.destroy
      end
    end
    
  end

  #シフト確定する(仮削除対象を削除)
  def perfect
    @events = current_master.individual_shifts.where(Temporary: false)
    #調整用に上がってきた全シフト対象
    @events.each do |shift|
        #仮削除がonのものを削除、それ以外は確定に変更していく
        if shift.deletable == true
            shift.destroy!
        else
            shift.Temporary = true
            shift.save
        end
    end
    flash[:success] = "シフトが完成しました！従業員の皆さんに共有しましょう！"
    redirect_to root_path
  end

  private
    def params_shift
      params.require(:individual_shift).permit(:start, :finish)
    end

    def params_plan
      params.require(:individual_shift).permit(:plan, :start)
    end
end
