module RenovateAudit
  module GitHub
    class PullRequest
      attr_reader :number, :title, :state, :labels, :updated_at

      def self.list_open(client, repository)
        client.pull_requests(repository.full_name, state: "open").map do |pr|
          new(
            number: pr.number,
            title: pr.title,
            state: pr.state,
            labels: pr.labels.map { |label| label.name },
            updated_at: pr.updated_at
          )
        end
      end

      def initialize(number:, title:, state:, labels:, updated_at:)
        @number = number
        @title = title
        @state = state
        @labels = labels
        @updated_at = updated_at
      end
    end
  end
end
