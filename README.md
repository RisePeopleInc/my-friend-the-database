## About

Note that Postgres 12+ is required to be installed first. The seeding script works with Ruby, so you'll need Ruby on your system too.

To create and seed the database, run `bundle` and then `bundle exec
./gen_demo_data.rb`. You may provide the following environment variables to
control the creation and seeding process:

- DB_NAME (default: `sales`, this is the name of the database that will be
  created)
- DB_USERNAME (default: the username of the executing the user)
- DB_PASSWORD (default: none)
- DB_HOST (default: `localhost`)
- DB_PORT (default: `5432)`
- INITIAL_DB_NAME (default: `postgres`, this is the database we initially connect
  to before creating the target database)

After you have completed the creation and seeding process, you may run any of
the sample queries. Have fun!
