class ShiftSeparation < ApplicationRecord
  belongs_to :master
  default_scope -> { order(start_time: :asc) }
  validates :name, presence: true, uniqueness: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validate  :start_end_check
  
  #start_timeとfinish_timeの大小関係を制限(start < finish => true)
  #正し、夜勤の時間帯設定(21時~)にはこの制限を解除する
  def start_end_check
    if self.start_time.present? && self.finish_time.present?
      errors.add(:finish_time, "が開始時刻を上回っています。正しく記入してください。") if self.start_time > self.finish_time && self.start_time.hour < 21
    end
  end
end