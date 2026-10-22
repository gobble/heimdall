FactoryBot.define do
  factory :fake_address do
    street1 { "939 Industrial Ave." }
    city { "Palo Alto" }
    state { "CA" }
    commercial { false }
    verified { true }
    sequence(:zip) { |n| (90000 + n).to_s }
  end

  factory :verification_response,
          class: Heimdall::Utils::VerificationResponse do
    street1 { "939 Industrial Ave" }
    street2 { "Apt. 1" }
    primary_field { "939 Industrial Ave" }
    city { "Palo Alto" }
    state { "CA" }
    zip_code { "94303" }
    deliverability { :deliverable }
    commercial { true }

    initialize_with { new(**attributes) }
  end
end
