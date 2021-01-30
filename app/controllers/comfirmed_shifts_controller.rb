class ComfirmedShiftsController < ApplicationController
  def index
    @events = current_staff.individual_shifts.where(Temporary: true).where(deletable: false)
  end
end
