class DeletableShiftsController < ApplicationController
    def index
        @events = current_master.individual_shifts.where(Temporary: false).where(deletable: true)
    end

    def restore
        @event = current_master.individual_shifts.find(params[:shift_id])
        render plain: render_to_string(partial: 'form_reborn', layout: false, locals: { event: @event })
    end

    def reborn
        @event = current_master.individual_shifts.find(params[:id])
        @event.deletable = false
        @event.save
    end
end
