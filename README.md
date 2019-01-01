# Recipppe

## Configuration

* Ruby 2.5.0
* Rails 5.2.2
* Postgres
* Heroku

## Running local

For Active Storage the default development bucket is at: `eu-west-3` with
bucket `recipppe-development`. You'll need environment variables:

  ```
  ENV['AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY']
  ```

For database, configure the environment variables then create and migrate database:

  ```
  ENV['POSTGRES_USER']
  ENV['POSTGRES_PASSWORD']
  ```

  ```
  $> rake db:create
  $> rake db:migrate
  $> heroku local
  ```

Run the server:

  ```
  $> rails server
  ```
