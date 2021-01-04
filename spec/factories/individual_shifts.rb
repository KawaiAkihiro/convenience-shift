FactoryBot.define do
  factory :shift1, class: IndividualShift do
    start { "2020-12-25 05:00:00" }
    finish { "2020-12-25 06:00:00" }
  end

  factory :shift2, class: IndividualShift do
    start { "2021-01-02 09:00:00" }
    finish { "2021-01-02 10:00:00"}
    confirm { false }
    Temporary { false }
  end

  factory :shift3, class: IndividualShift do
    start { "2020-12-01 09:00:00"}
    finish{ "2020-12-01 10:00:00"}
    confirm { false }
    Temporary { false }
  end
end
