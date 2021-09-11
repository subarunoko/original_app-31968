FactoryBot.define do
  factory :comment1, class: Comment do
    association :user
    rnd_text = Faker::Lorem.sentence

    text                  {rnd_text}
  end

  factory :comment2, class: Comment do
    association :user
    rnd_text = Faker::Lorem.sentence

    text                  {rnd_text}
  end
end
