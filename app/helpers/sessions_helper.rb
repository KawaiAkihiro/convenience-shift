module SessionsHelper

    def log_in(master)
        session[:master_id] = master.id
    end

    def current_master
        if session[:master_id]
            @current_master ||= Master.find_by(id:session[:master_id])
        end
    end

    def logged_in?
        !current_master.nil?
    end

    def log_out
        session.delete(:master_id)
        @current_master = nil
    end
end
