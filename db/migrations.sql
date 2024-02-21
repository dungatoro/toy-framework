/*
Migrations are added to this file in sequence.
Always make use of `if not exists` to avoid overwrites.
*/
-- Create the users table
create table if not exists users (
    id            integer primary key,
    email         text not null unique,
    username      text not null, 
    password_hash text not null
);
