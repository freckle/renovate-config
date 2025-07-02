if ENV["GITHUB_ACTIONS"] == "true"
  Rainbow.enabled = true # spoof tty detection
end

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
      [:not_configured, "not configured for Renovate", "This project's dependencies are not being automatically updated", "add a renovate.json"],
      [:stale_open, "with stale open Renovate PRs", "Renovate's updates are not making it to the main branch", "address failing CI"],
      [:no_release, "without any release workflow", "Renovate's updates are not being released", "add a .github/workflows/release.yml"],
      [:release_not_automatic, "without automatic release", "Renovate's updates are not being released automatically", "update the project to use semantic-release"],
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

      KEY_PHRASES.each do |key, phrase, problem, tip|
        repos = issues_by_key.fetch(key, [])

        if repos.any?
          puts "Found #{cyan(repos.size)} repositories #{magenta(phrase)}:"
          puts "  - #{repos.join("\n  - ")}"
          puts
          puts "  #{bright(problem)}"
          puts "  #{green("Tip:")} #{tip}"
          puts
        end
      end
    end

    private

    def bright(x)
      Rainbow(x).bright
    end

    def cyan(x)
      Rainbow(x).cyan
    end

    def green(x)
      Rainbow(x).green
    end

    def magenta(x)
      Rainbow(x).magenta
    end
  end
end
