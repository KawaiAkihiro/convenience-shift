class NoticesController < ApplicationController
    def index
        @notices = current_master.notices.all
    end

    def show
        @notice = current_master.notices.find(params[:id])
        @shift  = current_master.individual_shifts.find(@notice.shift_id)
        @old_staff = @shift.staff
        @new_staff = current_master.staffs.find(@notice.staff_id)
    end

    def update
        @notice = current_master.notices.find(params[:id])
        @shift  = current_master.individual_shifts.find(@notice.shift_id)
        @old_staff = @shift.staff

        if @notice.mode == "instead"
            @new_staff = current_master.staffs.find(@notice.staff_id)
        elsif @notice.mode == "delete"
            @new_staff = current_master.staffs.find_by(staff_number:0)
        end

        @shift.staff = @new_staff
        @shift.mode = nil
        @shift.save
        @notice.destroy!
        flash[:success] = "申請を反映しました！"
        redirect_to notices_path
    end

    def destroy
        @notice = current_master.notices.find(params[:id]).destroy!
        flash[:dange] = "申請を拒否したので変更はありません"
        redirect_to notices_path
    end
end
