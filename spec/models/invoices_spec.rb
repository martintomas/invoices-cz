require "rails_helper"

RSpec.describe Invoice, type: :model do
  subject { build(:invoice) }

  it { is_expected.to be_valid }
end