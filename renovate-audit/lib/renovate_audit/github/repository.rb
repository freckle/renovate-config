module RenovateAudit
  module GitHub
    class Repository
      attr_reader :name, :full_name, :archived, :forked

      def self.for_organization(client, organization)
        client.repos(organization).map do |repo|
          new(
            name: repo.name,
            full_name: repo.full_name,
            archived: repo.archived,
            forked: repo.forked,
          )
        end
      end

      def initialize(name:, full_name:, archived:, forked:)
        @name = name
        @full_name = full_name
        @archived = archived
        @forked = forked
      end
    end
  end
end
