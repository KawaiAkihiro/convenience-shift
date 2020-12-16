FactoryBot.define do
  factory :staff, class: Staff do
    staff_name { "河合彰紘" }
    staff_number { 145 }
    training_mode { false }
    created_at { 10.minutes.ago }
    password { "0000" }
    password_confirmation { "0000" }
    
  end

  factory :leader, class: Staff do
    staff_name { "平沼" }
    staff_number{ 168 }
    training_mode{ false }
    created_at { 1.hour.ago }
    password { "0000" }
    password_confirmation { "0000" }
  end

  factory :manager, class: Staff do
    staff_name { "松川" }
    staff_number{ 120 }
    training_mode{ false }
    created_at { Time.zone.now }
    password { "0000" }
    password_confirmation { "0000" }
  end
end