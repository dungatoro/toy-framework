# Simple Stack

This stack is deliberately under-engineered. It uses htmx to enhance raw html on
the frontend, sinatra to serve web pages on the backend, bash scripts and raw SQL
for managing the system.

User authentication is already set up.

## Frontend

`erb` files are stored in the `views` directory. The base stylesheet comes from 
PicoCSS; additional CSS is in the public directory.

## Backend

Sinatra is used to declare endpoints concisely, most endpoints calling `erb :page`
where `page` refers to a `page.erb` file in the `views` directory.

## Sysadmin

The `toy` executable script provides some basic functions for maintenance.
