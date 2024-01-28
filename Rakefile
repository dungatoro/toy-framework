# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength

require 'fileutils'
require 'sequel'

DB = Sequel.sqlite 'db/local.db'
MIGRATION_PATH = 'db/migrations'
namespace :db do
  Sequel.extension :migration

  desc 'Prints current schema version'
  task :version do
    version = (DB[:schema_info].first[:version] if DB.tables.include?(:schema_info)) || 0
    puts "Schema Version: #{version}"
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do
    Sequel::Migrator.run(DB, MIGRATION_PATH)
    Rake::Task['db:version'].execute
  end

  desc 'Perform rollback to specified target or full rollback as default'
  task :rollback, :target do |_t, args|
    args.with_defaults(target: 0)

    Sequel::Migrator.run(DB, MIGRATION_PATH, target: args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc 'Perform migration reset (full rollback and migration)'
  task :reset do
    Sequel::Migrator.run(DB, MIGRATION_PATH, target: 0)
    Sequel::Migrator.run(DB, MIGRATION_PATH)
    Rake::Task['db:version'].execute
  end

  desc 'generates a migration file with a timestamp and name'
  task :generate_migration, :name do |_, args|
    args.with_defaults(name: 'migration')

    migration_template = <<~MIGRATION
      Sequel.migration do
        up do
        end

        down do
        end
      end
    MIGRATION

    file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{args.name}.rb"
    FileUtils.mkdir_p(MIGRATIONS_PATH)

    File.open(File.join(MIGRATIONS_PATH, file_name), 'w') do |file|
      file.write(migration_template)
    end
  end
end
