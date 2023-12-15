require "rails_helper"
require 'concerns/recurringable_spec'

RSpec.describe Invoice, type: :model do
  subject { build(:invoice) }

  it { is_expected.to be_valid }

  it_behaves_like 'recurringable'
end