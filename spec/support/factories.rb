FactoryGirl.define do
  factory :fake_address do
    street1 "939 Industrial Ave."
    city "Palo Alto"
    state "CA"
    commercial false
    verified true
    sequence(:zip) { |n| (90000 + n).to_s }
  end

  factory :verification_response,
          class: Heimdall::Utils::VerificationResponse do
    primary_line "939 Industrial Ave"
    secondary_line "Apt. 1"
    deliverability "deliverable"
    city "Palo Alto"
    state "CA"
    zip_code 94303
    address_type "commercial"
    primary_number "939"
    street_predirection "N"
    street_name "Industrial"
    street_suffix "Ave"
    street_postdirection "W"
  end
end
