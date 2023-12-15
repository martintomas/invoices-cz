FactoryBot.define do
  factory :invoice_line do
    invoice
    quantity { 1 }
    price { 10.0 }
    description { Faker::Lorem.sentence }
  end
end