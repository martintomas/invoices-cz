FactoryBot.define do
  factory :recurring_profile do
    frequency { 'weekly' }

    trait :ends_after_date do
      ends_on { 1.year.from_now }
    end

    trait :ends_after_count do
      invoices_count { 0 }
      ends_after_count { 2 }
    end
  end
end