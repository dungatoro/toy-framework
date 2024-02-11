# Sequel Migrations
```bash
rake db:generate_migration[my_migration_name]
```
This will create a Sequel migration file YYYYmmddHHMMSS_my_migration_name.rb in 
the db/migrations directory.

In the migration file, you can define the up and down methods to apply and 
rollback the schema changes. For example:
```ruby
Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username, unique: true
      String :password_hash
    end
  end

  down do
    drop_table(:users)
  end
end
```
To run the migrations, use the rake db:migrate command. Sequel will run the up 
blocks for all migrations that have not yet been applied. If you want to migrate 
to a specific version, you can use the -M switch:
```bash
rake db:migrate VERSION=<version_number>
```
Remember to replace <version_number> with the version number you want to migrate 
to.

