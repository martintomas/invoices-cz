require "rails_helper"

RSpec.describe RecurringProfile, type: :model do
  subject { build(:recurring_profile) }

  it { is_expected.to be_valid }
end