require 'spec_helper'

RSpec.shared_examples_for 'recurringable' do
  let(:model) { described_class }

  describe 'hook #build_next_recurring_draft_if_necessary' do
    let(:record) { create model.to_s.underscore.to_sym }
    let(:draft) { Invoice.drafts.first }

    context 'when invoice has recurring profile turned off' do
      it 'does not create new draft' do
        record.touch
        expect(draft).to be_nil
      end
    end

    context 'when invoice has recurring profile turned on' do
      let!(:recurring_profile) { create :recurring_profile }

      context 'when draft already exists' do
        let!(:existing_draft) { create :invoice, :draft, recurring_profile: recurring_profile }

        it 'does not create new draft' do
          record.update! recurring_profile: recurring_profile
          expect(draft).to eq(existing_draft)
        end
      end

      context 'when there is no draft' do
        context 'when recurring profile already ended' do
          it 'does not create new draft' do
            allow(recurring_profile).to receive(:should_build_next_one?).and_return(false)
            record.update! recurring_profile: recurring_profile
            expect(draft).to be_nil
          end
        end

        context 'when recurring profile recommends to create new one' do
          it 'creates new draft' do
            allow(recurring_profile).to receive(:should_build_next_one?).and_return(true)
            record.update! recurring_profile: recurring_profile
            expect(draft).not_to be_nil
          end
        end
      end
    end
  end
end