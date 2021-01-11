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
end
