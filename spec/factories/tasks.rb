FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { false }
    due_date { Faker::Date.forward(days: 30) }

    trait :with_tags do
      after(:create) do |task|
        task.tags << create_list(:tag, 2)
      end
    end
  end
end
