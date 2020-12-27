FactoryBot.define do
  factory :individual_shift do
    start_time { "2020-12-25 05:35:43" }
    finish_time { "2020-12-25 05:35:43" }
    staff { nil }
    confirm { false }
    Temporary { false }
    deletable { false }
  end
end
