FactoryBot.define do
  factory :sleep_tracker do
    clocked_in_at { Time.current }
    clocked_out_at { Time.current + 8.hours }
    association :user
  end
end
