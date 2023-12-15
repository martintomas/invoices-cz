class Invoice < ApplicationRecord
  attribute :issued_on,    :date, default: -> { Time.zone.today }
  attribute :due_on,       :date, default: -> { Time.zone.today }
  attribute :tax_point_on, :date, default: -> { Time.zone.today }

  has_many :lines, class_name: 'InvoiceLine',
           dependent: :destroy, inverse_of: :invoice
  has_one :seller, dependent: :destroy, inverse_of: :invoice
  has_one :buyer,  dependent: :destroy, inverse_of: :invoice

  belongs_to :subscription, optional: true

  accepts_nested_attributes_for :seller
  accepts_nested_attributes_for :buyer
  accepts_nested_attributes_for :lines, allow_destroy: true

  validates :issued_on, presence: true

  before_save :calculate_total

  scope :drafts, -> { where number: nil }

  include Recurringable

  class << self
    def increment_number(number)
      digits = number.scan(/\d+$/).first || ''
      number.sub(/\d+$/, '') + digits.next
    end
  end

  def draft?
    number.blank?
  end

  private

  def exact_total
    lines.map(&:total).sum
  end

  def calculate_total
    self.total = exact_total
  end
end
