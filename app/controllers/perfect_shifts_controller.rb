class PerfectShiftsController < ApplicationController
  def index
    if logged_in?
        @events = current_master.individual_shifts.where(Temporary: true)
        @shift_separation = current_master.shift_separations.all
    end

    if logged_in_staff?
        @master = current_staff.master
        @events = @master.individual_shifts.where(Temporary: true)
        @shift_separation = @master.shift_separations.all
    end
  end

  def fill
    if logged_in_staff?
      @master = current_staff.master
      @id = params[:shift_id]
      @event = @master.individual_shifts.find(@id)
      @already = current_staff.individual_shifts.find_by(start: @event.start)
      if @already.nil?
        render plain: render_to_string(partial: 'form_fill', layout: false, locals: { event: @event })
      else      
        render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
      end
    end

    if logged_in?
      @event = current_master.individual_shifts.find(params[:shift_id])
      render plain: render_to_string(partial: 'info_event', layout: false, locals: { event: @event })
    end
  end

  def fill_in
    @master = current_staff.master
    @event = @master.individual_shifts.find(params[:id])
    @event.staff = current_staff
    @event.save
  end

  def change
    if logged_in_staff?
      @master = current_staff.master
      @event = @master.individual_shifts.find(params[:shift_id])
      @already = current_staff.individual_shifts.find_by(start: @event.start)
      if @event.staff != current_staff && @event.allDay == false
        if @already.nil? 
          render plain: render_to_string(partial: 'form_instead', layout: false, locals: { event: @event })
        else
          render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
        end
      elsif @event.staff != current_staff && @event.allDay == true
        render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
      elsif @event.staff == current_staff
        render plain: render_to_string(partial: 'form_delete', layout: false, locals: { event: @event }) 
      end
    end
  end

  def instead
    @master = current_staff.master
    @event = @master.individual_shifts.find(params[:id])
    @event.mode = "instead"
    @event.save
    @notice = @master.notices.new
    @notice.mode = "instead"
    @notice.staff_id = current_staff.id
    @notice.shift_id = @event.id
    @notice.save
  end

  def delete
    @event = current_staff.individual_shifts.find(params[:id])
    @event.mode = "delete"
    @event.save
    @master = current_staff.master
    @notice = @master.notices.new(params_notice)
    @notice.mode = "delete"
    @notice.staff_id = current_staff.id
    @notice.shift_id = @event.id
    @notice.save
  end

  private
    def params_notice
      params.require(:individual_shift).permit(:comment)
    end
end

