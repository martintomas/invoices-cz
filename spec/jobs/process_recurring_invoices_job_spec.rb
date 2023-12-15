require "rails_helper"

RSpec.describe ProcessRecurringInvoicesJob, type: :job do
  let!(:recurring_profile) { create :recurring_profile, invoices_count: 0 }
  let!(:invoice) { create :invoice, number: "Test13", recurring_profile: recurring_profile }
  let!(:past_draft) { create :invoice, :draft, due_on: Date.today, recurring_profile: recurring_profile }
  let!(:future_draft) { create :invoice, :draft, due_on: 1.day.from_now, recurring_profile: recurring_profile }

  it 'should update past draft to regular one and ignore future draft' do
    described_class.perform_now
    expect(past_draft.reload).not_to be_draft
    expect(future_draft.reload).to be_draft
  end

  it 'should update number of past draft' do
    described_class.perform_now
    expect(past_draft.reload.number).to eq("Test14")
  end

  it 'should update counting value of recurring_profile' do
    described_class.perform_now
    expect(recurring_profile.reload.invoices_count).to eq(1)
  end
end