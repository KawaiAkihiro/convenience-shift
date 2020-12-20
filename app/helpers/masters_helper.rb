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
end
