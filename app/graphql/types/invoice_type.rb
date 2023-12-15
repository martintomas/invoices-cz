# frozen_string_literal: true

module Types
  class InvoiceType < Types::BaseObject
    field :id, ID, null: false
    field :number, String
    field :issued_on, GraphQL::Types::ISO8601Date
    field :due_on, GraphQL::Types::ISO8601Date
    field :means_of_payment, String
    field :total, Float
    field :paid_at, GraphQL::Types::ISO8601Date
    field :submitted_at, GraphQL::Types::ISO8601Date
    field :deleted_at, GraphQL::Types::ISO8601Date
    field :state, Integer
  end
end