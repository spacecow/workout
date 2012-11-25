FactoryGirl.define do
  factory :comment do
    association :commenter, factory: :user
    content "Factory comment"
    association :commentable, factory: :post 
  end

  factory :current_state do
    day
    user
    weight 83
  end

  factory :day do
    sequence(:date){|n| "2012-08-#{n}"}
  end

  factory :noticement do
  end

  factory :notification do
    association :notifiable, factory: :comment
  end

  factory :post do
    association :author, factory: :user
    day
    sequence(:training_type_tokens){|n| "<<<Running#{n}>>>"}
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
