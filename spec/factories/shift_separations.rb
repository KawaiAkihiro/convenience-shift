FactoryBot.define do
  factory :morning_fast,  class: ShiftSeparation do
    name { "早朝" }
    start_time { "2000-01-01 07:00:00" }
    finish_time { "2000-01-01 10:00:00" }
    created_at { 1.hour.ago }
  end

  factory :morning_middle, class: ShiftSeparation do
    name { "午前" }
    start_time { "2000-01-01 10:00:00" }
    finish_time { "2000-01-01 14:00:00" }
    created_at { 1.minute.ago }
  end

  factory :over_night,   class: ShiftSeparation do
    name { "夜勤" }
    start_time { "2000-01-01 22:00:00" }
    finish_time { "2000-01-01 7:00:00" }
    created_at { 30.minutes.ago }
  end

end