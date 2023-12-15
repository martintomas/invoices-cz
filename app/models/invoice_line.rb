class InvoiceLine < ApplicationRecord
  belongs_to :invoice, inverse_of: :lines

  # default_scope { order(position: :asc, id: :asc) } # there is no such attribute in prepared db

  def total
    (quantity * price).round(2)
  end
end
