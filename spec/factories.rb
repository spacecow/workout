FactoryGirl.define do
  factory :comment do
    association :commenter, factory: :user
  end

  factory :day do
    date '2012-07-14'
  end

  factory :post do
    association :author, factory: :user
    day
  end

  factory :topentry do
    score 10
    user
    duration 5 
    category 'duration'
  end

  factory :training_type do
    name 'Factorywork'
  end

  factory :user do
    sequence(:email){|n| "test#{n}@example.com"}
    sequence(:userid){|n| "tester#{n}"}
    password 'secret'
  end
end
