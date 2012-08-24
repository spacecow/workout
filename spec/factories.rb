FactoryGirl.define do
  factory :day do
  end

  factory :post do
    association :author, factory: :user
    training_type
  end

  factory :training_type do
  end

  factory :user do
    sequence(:email){|n| "test#{n}@example.com"}
    sequence(:userid){|n| "tester#{n}"}
    password 'secret'
  end
end
