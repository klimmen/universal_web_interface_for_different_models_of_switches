
FactoryGirl.define do
 factory :switch do
   name  "zyxel3538_office"
   ip	 "172.24.24.24"
   login "admin"
   pass	 "password"
   snmp	 "q1w2e3r4"
 end

	factory :switch_model do
   name  "zyxel3538"
 end

 	factory :firmware do
   name  "V4.01"
   association(:switch_model)
 end

 	factory :mib do
 		name "getSwitchMAC"
 		value_oid_id "1.3.6.1.2.1.2.2.1.7"

    trait :with_firmware do
      after(:create) do |mib|
        mib.firmwares << create(:firmware)
      end
    end
 end


end