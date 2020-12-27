class Form::ShiftCollection < Form::Base
    FORM_COUNT = 10
    attr_accessor :shifts
    
    @staff = Staff.find(params[:staff_id])

    def inintializa(attributes = {})
        super attributes
        self.shifts = FORM_COUNT.times.map{ @staffs.individual_shifts.new() } unless
                                                       self.shifts.present?  
    end

    def shifts_attributes=(attributes)
        shifts = attributes.map{ |_, v| @staffs.individual_shifts.new(v) }
    end

    def save
        @staffs.individual_shifts do
            self.shifts.map do |shift|
                shift.save
            end
        end
            return true
        rescue => e
            return false
        
    end
end