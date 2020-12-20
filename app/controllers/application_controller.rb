class ApplicationController < ActionController::Base
    include SessionsHelper
    include StaffsSessionsHelper
    include MastersHelper
end
