require "rails_helper"

RSpec.describe "Graphql Query Invoices", type: :request do
  describe "InvoicesSearch resolver" do
    let!(:invoices) { create_list :invoice, 2 }
    let!(:draft) { create :invoice, :draft }

    context "when no filtering is used" do
      let(:query) { "query { invoices { collection { id } } }" }

      it "returns all invoices" do
        result = FoFrontendSchema.execute query
        expect(result['data']['invoices']['collection'].map { |r| r['id'].to_i }).to match_array(invoices.pluck(:id))
      end
    end

    context "when requesting only drafts" do
      let(:query) { "query { invoices(filters: {regular: false, drafts: true}) { collection { id } } }" }

      it "returns all invoices" do
        result = FoFrontendSchema.execute query
        expect(result['data']['invoices']['collection'].map { |r| r['id'].to_i }).to match_array([draft.id])
      end
    end

    context "when requesting drafts and regular invoices together" do
      let(:query) { "query { invoices(filters: {regular: true, drafts: true}) { collection { id } } }" }

      it "returns all invoices" do
        result = FoFrontendSchema.execute query
        expect(result['data']['invoices']['collection'].map { |r| r['id'].to_i })
          .to match_array(invoices.pluck(:id) + [draft.id])
      end
    end
  end
end