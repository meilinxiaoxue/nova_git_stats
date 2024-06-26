# frozen_string_literal: true

require_relative '../git_stats'
require 'thor'

module GitStats
  class CLI < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    option :path, aliases: '-p', default: '.', desc: 'Path to git repository from which statistics should be generated.'
    option :out_path, aliases: '-o', default: './git_stats', desc: 'Output path where statistics should be written.'
    option :language, aliases: '-l', default: 'en', desc: 'Language of written statistics.'
    option :first_commit_sha, aliases: '-f', desc: 'Commit from where statistics should start.'
    option :last_commit_sha, aliases: '-t', default: 'HEAD', desc: 'Commit where statistics should stop.'
    option :silent, aliases: '-s', type: :boolean, desc: 'Silent mode. Don\'t output anything.'
    option :tree_path, aliases: '-d', default: '.', desc: 'Tree path of where statistics should be generated.'
    option :comment_string, aliases: '-c', default: '//', desc: 'The string which is used for comments.'

    desc 'generate', 'Generates the statistics of a git repository'
    def generate
      I18n.locale = options[:language]
      GitStats::Generator.new(options) do |g|
        g.add_command_observer { |command, _result| puts command } unless options[:silent]
      end.render_all
    end

    desc 'version', 'Show NovaGitStats version number and quit'
    def version
      puts "NovaGitStats #{GitStats::VERSION}"
    end
    map %w(-v --version) => :version
  end
end
