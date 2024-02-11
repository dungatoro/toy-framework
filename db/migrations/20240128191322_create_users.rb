# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :username, unique: true
      String :password_hash
    end
  end

  down do
    drop_table(:users)
  end
end
