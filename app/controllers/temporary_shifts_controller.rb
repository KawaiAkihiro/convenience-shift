class TemporaryShiftsController < ApplicationController

  def index
    @event = current_master.individual_shifts.new
    @events = current_master.individual_shifts.where(Temporary: false).where(deletable: false)
  end

  def new_shift
    @event = current_master.individual_shifts.new
    @separations = current_master.shift_separations.all
    render plain: render_to_string(partial: 'form_new_shift', layout: false, locals: { event: @event, separations:@separations })
  end

  def new_plan
    if logged_in?
      @event = current_master.individual_shifts.new
      render plain: render_to_string(partial: 'form_new_plan', layout: false, locals: { event: @event })
    else
      render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
    end
  end

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
    @id = params[:shift_id]
    @event = current_master.individual_shifts.find(@id)
    render plain: render_to_string(partial: 'form_deletable', layout: false, locals: { event: @event })
  end

  def deletable
    @event = current_master.individual_shifts.find(params[:id])
    if @event.allDay == true
      @event.destroy
    else
      if @event.staff.staff_number != 0
        @event.deletable = true
        @event.save
        # 成功処理
      else
        @event.destroy
      end
    end
    
  end

  def perfect
    @events = current_master.individual_shifts.where(Temporary: false)
    @events.each do |shift|
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
