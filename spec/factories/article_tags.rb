FactoryBot.define do
  factory :article_tag do
    # association :user

    random = Random.new
    rnd_title = Faker::Lorem.sentence
    rnd_body = Faker::Lorem.sentence

    # title                 {"sample1"}
    # description           {"text"}
    title                 {rnd_title}
    # body                  {rnd_body}
    tag_ids               {"tag1"}

    # after(:build) do |item|
    #   # item.image.attach(io: File.open("public/images/test_sample1.png"), filename: "test_image.png")
    #   item.images.attach(io: File.open("public/images/test_sample1.png"), filename: "test_image.png")
    # end
  end
end