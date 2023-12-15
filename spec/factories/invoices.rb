FactoryBot.define do
  factory :invoice do
    number { Faker::Number.unique.number(digits: 6) }
    issued_on { Time.current }
    due_on { Time.current }

    after(:build) do |invoice|
      invoice.lines << build(:invoice_line, invoice: invoice)
    end

    trait :draft do
      number { nil }
    end
  end
end