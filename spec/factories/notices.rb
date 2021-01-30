FactoryBot.define do
  factory :notice do
    mode { "MyString" }
    shift_id { 1 }
    staff_id { 1 }
    master { nil }
  end
end
