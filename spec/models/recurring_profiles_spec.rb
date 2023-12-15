require "rails_helper"

RSpec.describe RecurringProfile, type: :model do
  subject { build(:recurring_profile) }

  it { is_expected.to be_valid }

  describe 'hook #update_recurring_invoices' do
    let!(:recurring_profile) { create :recurring_profile }
    let!(:invoice) { create :invoice, recurring_profile: recurring_profile }

    before do
      allow(recurring_profile).to receive(:invoices).and_return(OpenStruct.new(regular: [invoice]))
    end

    context 'when there is no draft' do
      it 'checks if draft should be created' do
        expect(invoice).to receive(:build_next_recurring_draft_if_necessary)
        recurring_profile.update! ends_after_count: 10
      end
    end

    context 'when there is draft' do
      before { create :invoice, :draft, recurring_profile: recurring_profile }

      it 'does not try to create new draft' do
        expect(invoice).not_to receive(:build_next_recurring_draft_if_necessary)
        recurring_profile.reload.update! ends_after_count: 10
      end
    end
  end

  describe '#should_build_next_one?' do
    let(:recurring_profile) { create :recurring_profile }

    context 'when end options is never' do
      before { allow(recurring_profile).to receive(:end_options).and_return('never') }

      it 'returns true' do
        expect(recurring_profile.should_build_next_one?).to be_truthy
      end
    end

    context 'when end options is after_count' do
      before { allow(recurring_profile).to receive(:end_options).and_return('after_count') }

      context 'when maximum number of invoices was already created' do
        before { recurring_profile.update! invoices_count: 11, ends_after_count: 10 }

        it 'returns false' do
          expect(recurring_profile.should_build_next_one?).to be_falsey
        end
      end

      context 'when maximum number of invoices was not created yet' do
        before { recurring_profile.update! invoices_count: 9, ends_after_count: 10 }

        it 'returns false' do
          expect(recurring_profile.should_build_next_one?).to be_truthy
        end
      end
    end

    context 'when end options is after_date' do
      before { allow(recurring_profile).to receive(:end_options).and_return('after_date') }

      context 'when date is already at past' do
        before { recurring_profile.update! ends_on: 1.week.ago }

        it 'returns false' do
          expect(recurring_profile.should_build_next_one?).to be_falsey
        end
      end

      context 'when date is at future' do
        before { recurring_profile.update! ends_on: 1.week.from_now }

        it 'returns false' do
          expect(recurring_profile.should_build_next_one?).to be_truthy
        end
      end
    end
  end

  describe '#end_options' do
    it 'returns after_count when ends_after_count attribute is present' do
      expect(RecurringProfile.new(ends_after_count: 10).end_options).to eq('after_count')
    end

    it 'returns after_date when ends_on attribute is present' do
      expect(RecurringProfile.new(ends_on: 1.week.from_now).end_options).to eq('after_date')
    end

    it 'returns never when there are no limitations' do
      expect(RecurringProfile.new.end_options).to eq('never')
    end
  end

  describe '#build_invoice' do
    subject { recurring_profile.build_invoice invoice }

    let(:recurring_profile) { create :recurring_profile, frequency: 'quaterly' }
    let(:invoice) { create :invoice, recurring_profile: recurring_profile }

    it 'clones invoice attributes' do
      expect(subject.attributes.except('id', 'created_at', 'updated_at', 'number', 'paid_at', 'issued_on', 'due_on'))
        .to eq(invoice.attributes.except('id', 'created_at', 'updated_at', 'number', 'paid_at', 'issued_on', 'due_on'))
    end

    it 'update new invoice dates based on recurring profile frequency' do
      new_invoice = subject
      expect(new_invoice.due_on).to eq(invoice.due_on + 3.months)
      expect(new_invoice.issued_on).to eq(invoice.issued_on + 3.months)
    end

    it 'clones invoice lines' do
      expect(subject.lines.map { |line| line.attributes.except('id', 'invoice_id')})
        .to eq(invoice.lines.map { |line| line.attributes.except('id', 'invoice_id')})
    end
  end
end