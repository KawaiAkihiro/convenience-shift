module IntegrationHelper
    def is_logged_in?
        !session[:master_id].nil?
    end

    def log_in_as1(master)
        session[:master_id] = master.id
    end

    def log_in_as2(master, password:"foobar",remember_me:'1')
        post login_path, params: { session: { store_name: master.store_name,
                                                password: password,
                                             remember_me: remember_me}}
    end
end

