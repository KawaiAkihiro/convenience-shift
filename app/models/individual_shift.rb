class IndividualShift < ApplicationRecord
  belongs_to :staff

  validates :start,  presence:true, uniqueness:true
  validates :finish, presence:true
  validate  :start_end_check
  
  #startとfinishの大小関係を制限(start < finish => true)
  #正し、夜勤の時間帯設定(21時~)にはこの制限を解除する
  def start_end_check
    if self.start.present? && self.finish.present?
      errors.add(:finish, "が開始時刻を上回っています。正しく記入してください。") if self.start.hour > self.finish.hour && self.start.hour <= 21
    end
  end
end
