FactoryBot.define do
  factory :chat1, class: Chat do
    rnd_text = Faker::Lorem.sentence

    content               {rnd_text}
  end

  factory :chat2, class: Chat do
    rnd_text = Faker::Lorem.sentence

    content               {rnd_text}
  end
end
