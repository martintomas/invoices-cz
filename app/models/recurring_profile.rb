class RecurringProfile < ActiveRecord::Base
  has_many :invoices, :foreign_key => 'recurring_profile_id'

  attr_accessor :end_options

  validates_presence_of     :frequency
  validates_inclusion_of    :frequency,   in: %w(weekly monthly quaterly halfyearly yearly)
  validates_inclusion_of    :end_options, in: %w(never after_count after_date)
  validates_numericality_of :ends_after_count, greater_than: 0, allow_nil: true, allow_blank: true

  before_save  :handle_end_options

  after_update :update_recurring_invoices

  def should_build_next_one?
  end

  def end_options
    return 'after_count' if ends_after_count.present?
    return 'after_date' if ends_on.present?

    'never'
  end

  def build_invoice(invoice)
  end

  protected

  def update_recurring_invoices
  end

  def handle_end_options
  end

end
