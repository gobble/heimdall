FactoryGirl.define do
  factory :fake_address do
    street1 "939 Industrial Ave."
    city "Palo Alto"
    state "CA"
    commercial false
    verified true
    sequence(:zip) { |n| (90000 + n).to_s }
  end
end
