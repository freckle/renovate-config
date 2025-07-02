module RenovateAudit
  class Options
    attr_reader :token, :organization, :excludes, :exit_code

    def initialize
      @token = ENV["GITHUB_TOKEN"]
      @organization = ENV["GITHUB_REPOSITORY_OWNER"]
      @excludes = []
      @exit_code = true

      parse!
    end

    private

    def parse!
      OptionParser.new do |parser|
        parser.banner = "Usage: renovate-audit [options]"

        parser.on("--org=ORG", "Organization to audit (default $GITHUB_REPOSITORY_OWNER)") do |org|
          @organization = org
        end

        parser.on("--exclude=NAME", "Exclude repository by NAME") do |name|
          @excludes << name
        end

        parser.on("--[no-]exit-code", "Exit with code 1 if issues are found (default: true)") do |exit_code|
          @exit_code = exit_code
        end

        parser.on("-h", "--help", "Print this help") do
          puts parser
          exit
        end
      end.parse!

      if token.nil?
        $stderr.puts "GITHUB_TOKEN environment variable must be set"
        exit 1
      end

      if organization.nil?
        $stderr.puts "The --org option or GITHUB_REPOSITORY_OWNER environment is required"
        exit 1
      end
    end
  end
end
