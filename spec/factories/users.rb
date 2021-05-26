FactoryBot.define do
  factory :user do
    nickname                {Faker::Name.initials(number: 2)}
    email                   {Faker::Internet.free_email}
    # password                {Faker::Internet.password(min_length: 6)}
    password                {"123abc"}
    password_confirmation   {password}

  end
end
