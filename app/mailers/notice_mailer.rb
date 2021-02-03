class NoticeMailer < ApplicationMailer

    add_template_helper(ActionView::Helpers::UrlHelper)

    default from: "convenience.shifts711@gmail.com"

    def send_when_create_notice(notice)
        @notice = notice
        @new_staff = notice.master.staffs.find(notice.staff_id)
        @shift = notice.master.individual_shifts.find(notice.shift_id)
        @old_staff = @shift.staff

        if notice.mode == "instead"
            subject = "[通知]シフト交代申請について #{notice.id}"
        elsif notice.mode == "delete"
            subject = "[通知]シフト削除申請について #{notice.id}"
        end
        mail to: notice.master.email, subject: subject
    end
end
