class ComfirmedShiftsController < ApplicationController
  def index
    @events = current_staff.individual_shifts.where(confirm: true).where(Temporary: false)
  end
end
