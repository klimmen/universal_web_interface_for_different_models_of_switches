FactoryGirl.define do
factory :user do
  email "test@test.com"
  password  "q1w2e3r4"
  password_confirmation "q1w2e3r4"


  factory :admin do
  	  email "admin@test.com"
      after(:create) {|user| user.add_role(:admin)}
  end

  factory :manager do
  	  email "manager@test.com"
      after(:create) {|user| user.add_role(:manager)}
  end
 end

end
