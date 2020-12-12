FactoryBot.define do
  factory :master do
    sequence(:store_name) {  |n| "My#{n}String" }
    user_name { "MyString" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end

  factory :master2, class: Master do
    sequence(:store_name) {  |n| "My#{n}String2" }
    user_name { "MyString" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
