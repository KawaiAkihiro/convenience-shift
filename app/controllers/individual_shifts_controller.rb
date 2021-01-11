class IndividualShiftsController < ApplicationController
    before_action :logged_in_staff ,except: [:index, :deletable, :perfect]

    require 'date'

    def index
    end

    def new
        @shift = current_staff.individual_shifts.new
        @shifts = current_staff.individual_shifts.where(confirm: false)
    end

    def create
        @shift = current_staff.individual_shifts.new(params_shift)
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

    def confirm_form
        @shifts = current_staff.individual_shifts.where(confirm: false)
    end
        

    def confirm
        @shifts = current_staff.individual_shifts.where(confirm: false)
        if @shifts.count == 0
            redirect_to new_individual_shift_path
        else
            @shifts.each do |shift|
                shift.confirm = true
                shift.save
            end
            redirect_to current_staff
        end
    end

    def confirmed
        @shifts = current_staff.individual_shifts.where(confirm: true)
    end

    def destroy
        @shift = current_staff.individual_shifts.find(params[:id]).destroy
        flash[:danger] = "消去完了しました。"
        redirect_to new_individual_shift_path
    end

    def deletable
        @shift = current_master.individual_shifts.find(params[:id])
        @shift.deletable = true
        if @shift.save!
            redirect_to confirmed_shift_master_path(current_master)  
        else
            render "show"
        end
        
    end

    def perfect
        @shifts = current_master.individual_shifts.where(confirm: true).where(Temporary: false)
        @shifts.each do |shift|
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
        if @shift.start.nil? || @shift.finish.nil?
                flash[:danger] = "時間が記入されていません"
                render new_individual_shift_path
        else
            if @shift.start.hour < @shift.finish.hour #日付を跨がない場合はそのまま,日付を跨ぐ場合は1日プラスする。
                @shift.finish = @shift.finish.change(year: @shift.start.year, month: @shift.start.month, day: @shift.start.day) 
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

      def logged_in_staff
        unless logged_in_staff?
            flash[:danger] = "ログインしてください"
            redirect_to staffs_login_path
        end
      end
end

