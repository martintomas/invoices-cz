class RecurringProfile < ActiveRecord::Base
  has_many :invoices, :foreign_key => 'recurring_profile_id'
  has_one :draft, -> { drafts }, class_name: 'Invoice'

  attr_accessor :end_options

  validates_presence_of     :frequency
  validates_inclusion_of    :frequency,   in: %w(weekly monthly quaterly halfyearly yearly)
  validates_inclusion_of    :end_options, in: %w(never after_count after_date)
  validates_numericality_of :ends_after_count, greater_than: 0, allow_nil: true, allow_blank: true

  before_save  :handle_end_options

  after_update :update_recurring_invoices

  def should_build_next_one?
    return invoices_count <= ends_after_count if end_options == 'after_count'
    return Date.today < ends_on if end_options == 'after_date'

    true
  end

  def end_options
    return 'after_count' if ends_after_count.present?
    return 'after_date' if ends_on.present?

    'never'
  end

  def build_invoice(invoice)
    new_invoice = invoices.build invoice.attributes.except 'id', 'number', 'paid_at', 'created_at', 'updated_at'
    new_invoice.issued_on = invoice.issued_on + frequency_to_dates
    new_invoice.due_on = invoice.due_on + frequency_to_dates
    invoice.lines.each { |line| new_invoice.lines.build line.attributes.except 'id' }
    new_invoice
  end

  protected

  def frequency_to_dates
    case frequency
    when 'weekly'
      1.week
    when 'monthly'
      1.month
    when 'quaterly'
      3.months
    when 'halfyearly'
      6.months
    when 'yearly'
      1.year
    end
  end

  def update_recurring_invoices
    invoices.last&.build_next_recurring_draft_if_necessary unless draft.present?
  end

  def handle_end_options
    # No idea what this should do :)
  end
end
