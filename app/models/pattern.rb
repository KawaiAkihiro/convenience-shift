class Pattern < ApplicationRecord
  belongs_to :staff

  def start_h
    if self.start.hour < 10
      "0#{self.start.hour}"
    else
      self.start.hour
    end
  end

  def finish_h
    self.finish.hour
  end

  def start_to_finish
    "#{self.start.strftime("%H:%M")}-#{self.finish.strftime("%H:%M")}"
  end
end
