module Types
  module Arguments
    class InvoiceInput < ::Types::BaseInputObject
      description "InvoiceInput"

      argument :regular, Boolean, required: false
      argument :drafts, Boolean, required: false
    end
  end
end