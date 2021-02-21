class PerfectShiftsController < ApplicationController
  def index
    #このページで全てのアクションを起こす
    if logged_in?
        @events = current_master.individual_shifts.where(Temporary: true)
    end

    if logged_in_staff?
        @master = current_staff.master
        @events = @master.individual_shifts.where(Temporary: true)
        @shift_separation = @master.shift_separations.all
    end
  end

  def new_plan
    if logged_in?
      @event = current_master.individual_shifts.new
      return_html("form_new_plan")
    else
      return_html("alert")
    end
  end

  def create_plan
    @event = current_master.individual_shifts.new(params_plan)
    @event.staff = current_master.staffs.find_by(staff_number: 0)
    @event.Temporary = true
    @event.save
    respond_to do |format|
      format.html { redirect_to temporary_shifts_path }
      format.js
    end
  end

  #空きシフトを埋めるmodalを返す
  def fill
    #両方ログイン中
    if logged_in? && logged_in_staff?
      #フォームのhtmlを返す
      fill_form

    #従業員のみログイン時
    elsif !logged_in? && logged_in_staff?
      #フォームのhtmlを返す
      fill_form

    #店長のみログイン時
    elsif logged_in? && !logged_in_staff?
      @event = current_master.individual_shifts.find(params[:shift_id])
      return_html("form_fill")
    
    end
  end

  #空きシフトを埋める処理
  def fill_in
    #両方ログイン中
    if logged_in? && logged_in_staff?
      #従業員を店長に設定
      instead_yellow_in_master

    #従業員のみログイン時
    elsif !logged_in? && logged_in_staff?

      @master = current_staff.master
      @event = @master.individual_shifts.find(params[:id])
      @event.staff = current_staff

    #店長のみログイン時
    elsif logged_in? && !logged_in_staff?  
      #従業員を店長に設定
      instead_yellow_in_master
    end
    
    @event.save
  end

  #シフトの変更のmodalを返す
  def change
    begin
      #両方ログイン時
      if logged_in? && logged_in_staff?
        @event = current_master.individual_shifts.find(params[:shift_id])
        #終日の予定をクリックした時

        masters_action

      #従業員のみログイン時
      elsif !logged_in? && logged_in_staff?
        @event = current_staff.master.individual_shifts.find(params[:shift_id])
        
        #他人のシフトをクリック
        if @event.staff != current_staff && @event.allDay == false 
          #モードによってmodalのhtmlを変更する
          if @event.mode.nil?
            return_html('form_instead')
          elsif @event.mode == "delete"
            return_html('alert')
          elsif @event.mode == "instead"
            return_html('alert')
          end
        #終日の予定をクリック
        elsif @event.staff != current_staff && @event.allDay == true
          return_html("alert")
        #自分の予定の場合
        elsif @event.staff == current_staff
          if @event.mode == "delete"
            return_html("already_delete")
          elsif @event.mode == "instead"
            return_html('already_instead')
          elsif @event.mode.nil?
            return_html('form_delete')
          end
        end

      #店長のみログイン時
      elsif logged_in? && !logged_in_staff?
        @event = current_master.individual_shifts.find(params[:shift_id])
        #終日の予定をクリックした時

        masters_action
      end
    rescue => exception
      #何もしない(祝日イベント対策)
    end
    
  end

  #交代申請処理
  def instead
    #シフトのモードを変更
    notice("instead")
  end

  #削除申請処理
  def delete
    #シフトのモードを変更
    notice("delete")
  end

  private

    def fill_form
      @event = current_staff.master.individual_shifts.find(params[:shift_id])
      return_html("form_fill")
    end

    def fill_yellow_in_master
      @event = current_master.individual_shifts.find(params[:id])
      @event.staff = current_master.staffs.find_by(staff_number:current_master.staff_number)
    end

    def masters_action
      unless @event.allDay
        return_html("alert")
      else
        return_html("plan_delete")
      end
    end

    def params_notice
      params.require(:individual_shift).permit(:comment)
    end

    def params_plan
      params.require(:individual_shift).permit(:plan, :start)
    end
end

