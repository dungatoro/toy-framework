/*
Migrations are added to this file in sequence.
Always make use of `if not exists` to avoid overwrites.
*/
create table if not exists users (
    user_id  integer primary key,
    username text not null unique,
    password text not null,
)
