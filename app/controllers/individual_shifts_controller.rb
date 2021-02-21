class IndividualShiftsController < ApplicationController
    before_action :logged_in_staff
    require 'date'

    def index
        #このページで全てのアクションを実行していく
        @events = current_staff.individual_shifts.where(Temporary: false)
        @shift_separation = current_staff.master.shift_separations.all
    end

    def new
        @event = current_staff.individual_shifts.new
        @patterns = current_staff.patterns.all
        #modal用のhtmlを返す
        render plain: render_to_string(partial: 'form_new', layout: false, locals: { event: @event, patterns: @patterns })
    end

    def create
        @event = current_staff.individual_shifts.new(params_shift)
        change_finishDate #日付を自動調整
        #同じ時間のシフトを捜索
        @already_event = current_staff.individual_shifts.where(start:@event.start).where(finish:@event.finish)
        
        #シフトパターンを作成
        @pattern = current_staff.patterns.new(params_shift) 
        @already_pattern = current_staff.patterns.where(start: @pattern.start).where(finish: @pattern.finish)
        
        #すでに同じシフトを登録していないか判定
        unless @already_event.present?
            if @event.save  
                #過去に同じ時間帯に登録したことがなければ新しい登録パターンを追加
                unless @already_pattern.present?
                    @pattern.save
                end
            else
                respond_to do |format|
                    format.js {render partial: "error" }
                end
            end
        else
            #被りエラーを表示する
            respond_to do |format|
                format.js {render partial: "duplicate" }
            end        
        end 
    end 


    def remove
        begin
            @id = params[:shift_id]
            @event = current_staff.individual_shifts.find(@id)
            #削除する用の
            render plain: render_to_string(partial: 'form_delete', layout: false, locals: { event: @event })
        rescue => exception
            #何もしない(祝日のイベントに反応しない対策)
        end
    end


    def destroy
        #両方でログイン中
        if logged_in_staff? && logged_in?
            @event = current_master.individual_shifts.find(params[:id]).destroy
        #従業員のみログイン中
        elsif logged_in_staff? && !logged_in?
            @event = current_staff.individual_shifts.find(params[:id]).destroy
        #店長のみログイン中
        elsif logged_in? && !logged_in_staff?
            @event = current_master.individual_shifts.find(params[:id]).destroy
        end
    end

    def finish
        flash[:success] = "登録を終了しました！"
        redirect_to root_path
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

