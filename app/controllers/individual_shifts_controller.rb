class IndividualShiftsController < ApplicationController
    require 'date'

    def new
        @shift = current_staff.individual_shifts.build
        @shifts = current_staff.individual_shifts.where(confirm: false)
    end

    def create
        @shift = current_staff.individual_shifts.build(params_shift)
        
            change_finishDate
            if @shift.save
              #ボタンで連続投稿を可能にしている。
                if params[:commit] == "登録"
                    flash[:success] = "登録が完了しましたが確定はまだしていません！"
                
                    redirect_to current_staff
                elsif params[:commit] == "もう一度"
                    flash[:success] = "もう一度登録してください" 
                    redirect_to new_individual_shift_path
                end
            else
                render 'new'
            end
    end

    def index
        @shifts = current_master.individual_shifts.all
    end
        

    def confirm
        @shifts = current_staff.individual_shifts.where(confirm: false)
        @shifts.each do |shift|
            shift.update(confirm: true)
        end
        redirect_to current_staff
    end

    private
      def params_shift
        params.require(:individual_shift).permit(:start, :finish)
      end

      #退勤時間の日付を出勤時間の日付に合わせる
      def change_finishDate  
        
          #日付を跨がない場合はそのまま,日付を跨ぐ場合は1日プラスする。 
        if @shift.start.hour < @shift.finish.hour
            @shift.finish = @shift.finish.change(year: @shift.start.year, month: @shift.start.month,day: @shift.start.day) 
        else  
            last_day = Date.new(@shift.start.year,@shift.start.month,-1).day #月末の日にちを取得
            if @shift.start.month == 12 && @shift.start.day == 31            #大晦日
                @shift.finish = @shift.finish.change(year: @shift.start.year + 1 ,  month: 1, day: 1)
            elsif !(@shift.start.month == 12) && @shift.start.day == last_day #普通の月末
                @shift.finish = @shift.finish.change(year: @shift.start.year,  month: @shift.start.month + 1, day: 1)
            else #月末でもない日
                @shift.finish = @shift.finish.change(year: @shift.start.year,  month: @shift.start.month,     day: @shift.start.day + 1)
            end
        end  
      end 
end

