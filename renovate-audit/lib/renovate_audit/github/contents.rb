module RenovateAudit
  module GitHub
    class Contents
      attr_reader :content

      def self.get(client, repository, path)
        contents = client.contents(repository.full_name, path: path)
        new(Base64.decode64(contents.content))
      rescue Octokit::NotFound
        nil
      end

      def initialize(content)
        @content = content
      end
    end
  end
end
