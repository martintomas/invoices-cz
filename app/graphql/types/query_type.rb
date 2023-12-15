module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :posts, 'Get posts', resolver: Resolvers::PostsSearch
    field :invoices, 'Get invoices', resolver: Resolvers::InvoicesSearch
  end
end
