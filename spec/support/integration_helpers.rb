module IntegrationHelper
    def is_logged_in?
        !session[:master_id].nil?
    end

    def is_logged_in_staff?
        !session[:staff_id].nil?
    end

    def log_in_as1(master, password:"foobar")
        post login_path, params: { session: {store_name: master.store_name,
                                              password: password}}
    end

    def log_in_as2(master, password:"foobar",remember_me:'1')
        post login_path, params: { session: { store_name: master.store_name,
                                                password: password,
                                             remember_me: remember_me}}
    end

    def log_in_staff(staff,password:"0000", store_name:"store")
        post staffs_login_path, params: { staffs_session: {store_name: store_name,
                                                  staff_number: staff.staff_number,
                                                  password: password}}
    end
end

