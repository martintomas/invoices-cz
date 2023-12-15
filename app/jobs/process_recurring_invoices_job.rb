class ProcessRecurringInvoicesJob < ApplicationJob
  def perform
    Invoice.transaction do
      Invoice.drafts.includes(recurring_profile: :invoices).where(due_on: ..Time.current).each do |invoice|
        last_invoice = invoice.recurring_profile.invoices.regular.last
        invoice.recurring_profile.update! invoices_count: invoice.recurring_profile.invoices_count + 1
        invoice.update! number: Invoice.increment_number(last_invoice.number)
      end
    end
  end
end
