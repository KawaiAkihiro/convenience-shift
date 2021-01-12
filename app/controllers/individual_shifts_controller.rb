class IndividualShiftsController < ApplicationController
    before_action :logged_in_staff ,except: [:index, :deletable, :perfect]

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
        # respond_to do |format|
        #     if @event.save
        #         format.html { redirect_to individual_shifts_path }
        #     else
        #         format.html { render :new}
        #     end
        # end
        
        
    end

    def confirm_form
        @events = current_staff.individual_shifts.where(confirm: false)
    end
        

    def confirm
        @events = current_staff.individual_shifts.where(confirm: false)
        if @events.count == 0
            redirect_to new_individual_shift_path
        else
            @events.each do |shift|
                shift.confirm = true
                shift.save
            end
            redirect_to current_staff
        end
    end

    def confirmed
        @events = current_staff.individual_shifts.where(confirm: true)
    end

    def destroy
        @event = current_staff.individual_shifts.find(params[:id]).destroy
        flash[:danger] = "消去完了しました。"
        redirect_to new_individual_shift_path
    end

    def deletable
        @event = current_master.individual_shifts.find(params[:id])
        @event.deletable = true
        if @event.save!
            redirect_to confirmed_shift_master_path(current_master)  
        else
            render "show"
        end
        
    end

    def perfect
        @events = current_master.individual_shifts.where(confirm: true).where(Temporary: false)
        @events.each do |shift|
            if shift.deletable == true
                shift.destroy!
            else
                shift.Temporary = true
                shift.save
            end
        end
        # @perfect_shifts = current_master.individual_shifts.where(confirm: true).where(Temporary: false).where(deletable: false)
        # @perfect_shifts.each do |shift|
        #     shift.Temporary = true
        #     shift.save
        # end
        redirect_to current_master
    end


    private
      def params_shift
        params.require(:individual_shift).permit(:start, :finish)
      end

      #退勤時間の日付を出勤時間の日付に合わせる
      def change_finishDate 
        if @event.start.hour < @event.finish.hour #日付を跨がない場合はそのまま,日付を跨ぐ場合は1日プラスする。
            @event.finish = @event.finish.change(year: @event.start.year, month: @event.start.month, day: @event.start.day) 
        else  
            last_day = Date.new(@event.start.year,@event.start.month,-1).day #月末の日にちを取得
            if @event.start.month == 12 && @event.start.day == 31            #大晦日
                @event.finish = @event.finish.change(year: @event.start.year + 1 ,  month: 1, day: 1)
            elsif !(@event.start.month == 12) && @event.start.day == last_day #普通の月末
                @event.finish = @event.finish.change(year: @event.start.year,  month: @event.start.month + 1, day: 1)
            else #月末でもない日
                @event.finish = @event.finish.change(year: @event.start.year,  month: @event.start.month,     day: @event.start.day + 1)
            end
        end
      end

      def logged_in_staff
        unless logged_in_staff?
            flash[:danger] = "ログインしてください"
            redirect_to staffs_login_path
        end
      end
end

