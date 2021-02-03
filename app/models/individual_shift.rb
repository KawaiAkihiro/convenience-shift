class IndividualShift < ApplicationRecord
  belongs_to :staff

  has_one :master, through: :staff

  default_scope -> { order(start: :asc) }
  validate  :start_end_check
  
  #startとfinishの大小関係を制限(start < finish => true)
  #正し、夜勤の時間帯設定(21時~)にはこの制限を解除する
  def start_end_check
    if self.start.present? && self.finish.present?
      errors.add(:finish, "が開始時刻を上回っています。正しく記入してください。") if self.start.hour >= self.finish.hour && self.start.hour <= 21
    end
  end

  def start_time
    self.start
  end

  def parent
    if self.staff.staff_number == 0
      if self.plan == nil
        " "
      else
        self.plan
      end
    else
      self.staff.staff_name
    end
    
  end

  def id_parent
    str = [self.id.to_s, self.staff.staff_name]
    return str.join(" ")
  end

  def allDay
    unless self.finish.present?
      true
    else
      false
    end
  end

  def color
    if self.staff.training_mode == true
      "red"
    else
      "black"
    end
  end

  def time
    str = [ "#{self.start.strftime("%H")}" + "時", "#{self.finish.strftime("%H")}" + "時" ]
    return str.join(" ~ ")
    
  end

  def backgroundColor
    if self.staff.staff_number == 0 && self.finish != nil
      "yellow"
    else
      "white"
    end
  end
end
