class ApplicationController < ActionController::Base
    include SessionsHelper
    include MastersHelper
    include IndividualShiftsHelper
end
