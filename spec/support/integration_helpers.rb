module IntegrationHelpers
    def is_logged_in?
        !session[:master_id].nil?
    end
end