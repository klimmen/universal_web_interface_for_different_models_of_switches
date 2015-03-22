


FactoryGirl.define do
 factory :person do
  email "test@test.com"
  password  "q1w2e3r4"
  password_confirmation "q1w2e3r4"
 end

  factory :admin do
      after(:create) {|user| user.add_role(:admin)}
  end

  factory :user do
      after(:create) {|user| user.add_role(:user)}
  end
end
