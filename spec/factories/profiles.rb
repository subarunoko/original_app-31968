FactoryBot.define do
  factory :profile do
    association :user

    random = Random.new
    rnd_language = random.rand(1..16)
    rnd_description = Faker::Lorem.sentence

    # description           {"text"}  
    description           {rnd_description}
    language_id           {rnd_language}

    # after(:build) do |item|
    #   # item.image.attach(io: File.open("public/images/test_sample1.png"), filename: "test_image.png")
    #   item.images.attach(io: File.open("public/images/test_sample1.png"), filename: "test_image.png")
    # end
  end
end
