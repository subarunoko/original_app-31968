FactoryBot.define do
  factory :tag do
    # association :article

    random = Random.new
    rnd_num = random.rand(2..10)
    name  {"tag#{rnd_num}"}
    # name  {"tag1"}
    # created_at { Faker::Time.between(5.days.ago, 3.days.ago, :all) }
    # updated_at { Faker::Time.between(2.days.ago, 1.days.ago, :all) } 
    created_at { "2021/09/06" }
    updated_at { "2021/09/06" } 
  end
end