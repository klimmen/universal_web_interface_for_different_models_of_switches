
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
end