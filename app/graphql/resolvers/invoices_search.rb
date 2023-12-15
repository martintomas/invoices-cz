require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class InvoicesSearch < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    DEFAULT_PER_PAGE = 5

    scope { Invoice.all.order(created_at: :desc) }

    type Types::InvoiceType.collection_type, null: false

    option :limit, type: ::Types::Arguments::LimitInput, with: :apply_limit, default: { limit: DEFAULT_PER_PAGE }
    option :filters, type: ::Types::Arguments::InvoiceInput, with: :apply_filter, default: { regular: true, drafts: false }

    def apply_filter(scope, value)
      return if value[:regular] && value[:drafts]
      return scope.regular if value[:regular]
      return scope.drafts if value[:drafts]

      scope.none
    end

    def apply_limit(scope, value)
      scope.limit(value[:limit] || DEFAULT_PER_PAGE)
    end
  end
end
