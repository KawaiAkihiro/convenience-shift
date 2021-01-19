module MastersHelper
    def logged_in_master
        unless logged_in?
          flash[:danger] = "ログインしてください"
          redirect_to login_url
        end
    end

    def corrent_master
      @master = Master.find(params[:id])
      redirect_to(root_url) unless current_master?(@master)
    end 

    def log_in_staff(staff)
      session[:staff_id] = staff.id
    end

  def current_staff
      if(staff_id=session[:staff_id])
          @current_staff ||= Staff.find_by(id:staff_id)
      end
  end

  def current_staff?(staff)
      staff && staff == current_staff
  end

  def log_out_staff
      session.delete(:staff_id)
      @current_staff = nil
  end

  def logged_in_staff?
      !current_staff.nil?
  end
end
