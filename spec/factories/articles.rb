# FactoryBot.define do
#   factory :article1, class: Article do
#     association :user
#     # association :tag

#     random = Random.new
#     rnd_title = Faker::Lorem.sentence
#     rnd_body = Faker::Lorem.sentence

#     title                 {rnd_title}
#     body                  {rnd_body}
#     # tag_ids               {"tag1"}

#     after(:create) do |article|
#       create_list(:article_tag1, 1, article: article, tag: create(:tag))
#     end
#   end
#   factory :article2, class: Article do
#     association :user
#     # association :tag

#     random = Random.new
#     rnd_title = Faker::Lorem.sentence
#     rnd_body = Faker::Lorem.sentence

#     title                 {rnd_title}
#     body                  {rnd_body}
#     # tag_ids               {"tag1"}
#   end
# end

FactoryBot.define do
  factory :article1, class: Article do
    association :user
    
    random = Random.new
    rnd_title = Faker::Lorem.sentence
    rnd_body = Faker::Lorem.sentence

    title                 {rnd_title}
    body                  {rnd_body}
    # tag_ids               {"tag1"}
  end
  factory :article2, class: Article do
    association :user

    random = Random.new
    rnd_title = Faker::Lorem.sentence
    rnd_body = Faker::Lorem.sentence

    title                 {rnd_title}
    body                  {rnd_body}
    # tag_ids               {"tag1"}
  end

end