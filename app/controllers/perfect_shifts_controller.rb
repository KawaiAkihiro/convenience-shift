class PerfectShiftsController < ApplicationController
  def index
    if logged_in?
        @events = current_master.individual_shifts.where(Temporary: true)
    end

    if logged_in_staff?
        @master = current_staff.master
        @events = @master.individual_shifts.where(Temporary: true)
    end
  end

  def fill
    if logged_in_staff?
      @master = current_staff.master
      @id = params[:shift_id]
      @event = @master.individual_shifts.find(@id)
      render plain: render_to_string(partial: 'form_fill', layout: false, locals: { event: @event })
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

end
