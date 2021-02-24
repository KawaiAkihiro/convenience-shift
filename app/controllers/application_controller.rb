class ApplicationController < ActionController::Base
    include SessionsHelper
    include MastersHelper
    include IndividualShiftsHelper
    include PerfectShiftsHelper
end
