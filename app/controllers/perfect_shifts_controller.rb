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
      render plain: render_to_string(partial: 'form_new_plan', layout: false, locals: { event: @event })
    else
      render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
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

  def fill
    if logged_in? && logged_in_staff?
      @master = current_staff.master
      @id = params[:shift_id]
      @event = @master.individual_shifts.find(@id)
      @already = current_staff.individual_shifts.find_by(start: @event.start)
      if @already.nil?
        render plain: render_to_string(partial: 'form_fill', layout: false, locals: { event: @event })
      else      
        render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
      end

    elsif !logged_in? && logged_in_staff?
      @master = current_staff.master
      @id = params[:shift_id]
      @event = @master.individual_shifts.find(@id)
      @already = current_staff.individual_shifts.find_by(start: @event.start)
      if @already.nil?
        render plain: render_to_string(partial: 'form_fill', layout: false, locals: { event: @event })
      else      
        render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
      end

    elsif logged_in? && !logged_in_staff?
      @event = current_master.individual_shifts.find(params[:shift_id])
      render plain: render_to_string(partial: 'form_fill', layout: false, locals: { event: @event })
    
    end
  end

  def fill_in
    if logged_in? && logged_in_staff?
      @master = current_staff.master
      @event = @master.individual_shifts.find(params[:id])
      @event.staff = current_staff

    elsif !logged_in? && logged_in_staff?
      @master = current_staff.master
      @event = @master.individual_shifts.find(params[:id])
      @event.staff = current_staff

    elsif logged_in? && !logged_in_staff?  
      @event = current_master.individual_shifts.find(params[:id])
      @event.staff = current_master.staffs.find_by(staff_number:current_master.staff_number)
    end
    
    @event.save
  end

  def change
    begin
      #両方ログイン時
      if logged_in? && logged_in_staff?
        @event = current_master.individual_shifts.find(params[:shift_id])
        #終日の予定をクリックした時
        unless @event.allDay
          render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
        else
          render plain: render_to_string(partial: 'plan_delete', layout: false, locals: { event: @event })
        end

      #従業員のみログイン時
      elsif !logged_in? && logged_in_staff?
        @event = current_staff.master.individual_shifts.find(params[:shift_id])
        
        #他人のシフトをクリック
        if @event.staff != current_staff && @event.allDay == false 
          #モードによってmodalのhtmlを変更する
          if @event.mode.nil?
            render plain: render_to_string(partial: 'form_instead', layout: false, locals: { event: @event })
          elsif @event.mode == "delete"
            render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
          elsif @event.mode == "instead"
            render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
          end
        #終日の予定をクリック
        elsif @event.allDay == true
          render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
        #自分の予定でモードを持っている場合
        elsif @event.staff == current_staff && @event.mode == "delete"
          render plain: render_to_string(partial: 'already_delete', layout: false, locals: { event: @event })
        elsif @event.staff == current_staff && @event.mode == "instead"
          render plain: render_to_string(partial: 'already_instead', layout: false, locals: { event: @event })
        elsif @event.staff == current_staff && @event.mode.nil?
          render plain: render_to_string(partial: 'form_delete', layout: false, locals: { event: @event }) 
        end

      #店長のみログイン時
      elsif logged_in? && !logged_in_staff?
        @event = current_master.individual_shifts.find(params[:shift_id])
        #終日の予定をクリックした時
        unless @event.allDay
          render plain: render_to_string(partial: 'alert', layout: false, locals: { event: @event })
        else
          render plain: render_to_string(partial: 'plan_delete', layout: false, locals: { event: @event })
        end
      end
    rescue => exception
      #何もしない(祝日イベント対策)
    end
    
  end

  def instead
    @master = current_staff.master

    #シフトのモードを変更
    @event = @master.individual_shifts.find(params[:id])
    @event.mode = "instead"
    @event.save

    #通知を作成
    @notice = @master.notices.new
    @notice.mode = "instead"
    @notice.staff_id = current_staff.id
    @notice.shift_id = @event.id
    @notice.save

    #メール機能がオンなら通知を送信
    if @master.onoff_email
      NoticeMailer.send_when_create_notice(@notice).deliver
    end
  end

  def delete
    #シフトのモードを変更
    @master = current_staff.master

    @event = current_staff.individual_shifts.find(params[:id])
    @event.mode = "delete"
    @event.save

    #通知を作成
    @notice = @master.notices.new(params_notice)
    @notice.mode = "delete"
    @notice.staff_id = current_staff.id
    @notice.shift_id = @event.id
    @notice.save

    #メール機能がオンなら通知を送信
    if @master.onoff_email
      NoticeMailer.send_when_create_notice(@notice).deliver
    end
  end

  private
    def params_notice
      params.require(:individual_shift).permit(:comment)
    end

    def params_plan
      params.require(:individual_shift).permit(:plan, :start)
    end
end

