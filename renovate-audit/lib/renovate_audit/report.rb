module RenovateAudit
  class Report
    AUDIT_PATHS = [
      "renovate.json",
      ".github/workflows/release.yml",
    ]

    STALE_DAYS = 5
    STALE_CUTOFF = Time.now - (60 * 60 * 24 * STALE_DAYS)

    Issue = Struct.new(:key, :repository)

    KEY_PHRASES = [
      [:not_configured, "not configured for Renovate", "add a renovate.json"],
      [:stale_open, "with stale open Renovate PRs", "these may be failing CI"],
      [:no_release, "without any release workflow", "add a .github/workflows/release.yml"],
      [:release_not_automatic, "without automatic release", "update the project to use semantic-release"],
    ]

    attr_reader :issues

    def initialize
      @issues = []
    end

    def audit_repository(repository, pull_requests, contents)
      if !contents["renovate.json"]
        self.issues << Issue.new(:not_configured, repository)
        return # no need to check further
      end

      pr = pull_requests.select { |pr| pr.labels.include?('renovate') }.min_by(&:updated_at)

      if pr && pr.updated_at < STALE_CUTOFF
        self.issues << Issue.new(:stale_open, repository)
      end

      release = contents[".github/workflows/release.yml"]

      if release.nil?
        self.issues << Issue.new(:no_release, repository)
      end

      if release && !release.content.include?("semantic-release")
        self.issues << Issue.new(:release_not_automatic, repository)
      end
    end

    def render_issues
      issues_by_key = self.issues.reduce({}) do |hash, issue|
        hash[issue.key] ||= []
        hash[issue.key] << issue.repository.full_name
        hash
      end

      KEY_PHRASES.each do |key, phrase, tip|
        repos = issues_by_key.fetch(key, [])

        if repos.any?
          puts "Found #{repos.size} repositories #{phrase}:"
          puts "  - #{repos.join("\n  - ")}"
          puts
          puts "  => Tip: #{tip}"
          puts
        end
      end
    end
  end
end
