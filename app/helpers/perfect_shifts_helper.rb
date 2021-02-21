module PerfectShiftsHelper
    def notice(mode)
        @master = current_staff.master

        @event = @master.individual_shifts.find(params[:id])
        @event.mode = mode
        @event.save

        #通知を作成
        @notice = @master.notices.new
        @notice.mode = mode
        @notice.staff_id = current_staff.id
        @notice.shift_id = @event.id
        @notice.save

        #メール機能がオンなら通知を送信
        if @master.onoff_email
        NoticeMailer.send_when_create_notice(@notice).deliver
        end
    end

    def return_html(html)
        render plain: render_to_string(partial: html, layout: false, locals: { event: @event })
    end
end
