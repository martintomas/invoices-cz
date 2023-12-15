module Recurringable
  extend ActiveSupport::Concern
  included do
    belongs_to :recurring_profile, optional: true

    accepts_nested_attributes_for :recurring_profile, allow_destroy: true

    after_destroy :destroy_recurring_profile
    after_save  :build_next_recurring_draft_if_necessary
  end

  def build_next_recurring_draft_if_necessary
    return if draft? || recurring_profile.blank? || recurring_profile.draft.present?

    recurring_profile.build_invoice(self).save! if recurring_profile.should_build_next_one?
  end
end
