class IndividualShiftsController < ApplicationController
    before_action :logged_in_staff ,except: [:index, :deletable, :perfect, :destroy]
    require 'date'

    def index
        @events = current_staff.individual_shifts.where(confirm: false)
    end

    def new
        @event = current_staff.individual_shifts.new
        render plain: render_to_string(partial: 'form_new', layout: false, locals: { event: @event })
    end

    def create
        @event = current_staff.individual_shifts.new(params_shift)
        change_finishDate
        @event.save  
    end 

    def confirm
        @events = current_staff.individual_shifts.where(confirm: false)
        if @events.count == 0
            flash[:danger] = "提出されたシフトがありません"
            # render "index"
            redirect_to individual_shifts_path
        else
            @events.each do |shift|
                shift.confirm = true
                shift.save
            end
            flash[:success] = "提出が完了しました"
            redirect_to current_staff
        end
    end

    def remove
        @id = params[:shift_id]
        @event = current_staff.individual_shifts.find(@id)
        render plain: render_to_string(partial: 'form_delete', layout: false, locals: { event: @event })
    end


    def destroy
        if logged_in_staff? && logged_in?
            @event = current_master.individual_shifts.find(params[:id]).destroy
        elsif logged_in_staff? && !logged_in?
            @event = current_staff.individual_shifts.find(params[:id]).destroy
        elsif logged_in? && !logged_in_staff?
            @event = current_master.individual_shifts.find(params[:id]).destroy
        end
        
        # flash[:danger] = "消去完了しました。"
        # redirect_to individual_shifts_path
    end

    private
      def params_shift
        params.require(:individual_shift).permit(:start, :finish)
      end

      def logged_in_staff
        unless logged_in_staff?
            flash[:danger] = "ログインしてください"
            redirect_to staffs_login_path
        end
      end
end

