#! /usr/bin/env ruby
require 'sequel'
require 'faker'

module GenDemoData
  extend self

  NUM_PRODUCTS = 100
  NUM_SALES_REPS = 100
  NUM_CUSTOMERS = 1000
  NUM_ORDERS = 10000

  INITIAL_DB_NAME = ENV['INITIAL_DB_NAME'] || 'postgres'

  DB_NAME = ENV['DB_NAME'] || 'sales'
  DB_USERNAME = ENV['DB_USERNAME'] || ENV['USER']
  DB_PASSWORD = ENV['DB_PASSWORD'] 
  DB_HOST = ENV['DB_HOST'] || 'localhost'
  DB_PORT = ENV['DB_PORT'] || 5432

  def run
    if DB_USERNAME.empty?
      puts 'no postgres username provided'
    end

    puts 'starting...'
    create_database; puts 'database created'
    db = connect_to_database(DB_NAME) 
    create_tables(db); puts 'schema loaded'
    seed_database(db); puts 'seeding completed'
    puts 'done! you can now execute any of the sample queries'
  end

  def connection_string(database_name)
    "postgres://#{DB_USERNAME}:#{DB_PASSWORD}@#{DB_HOST}:#{DB_PORT}/#{database_name}"
  end

  def connect_to_database(database_name)
    Sequel.connect(connection_string(database_name))
  end

  def create_database
    initial_db = connect_to_database(INITIAL_DB_NAME)
    initial_db.run("create database #{DB_NAME}")
  end

  def create_tables(db)
    db.create_table :customers do
      primary_key :id
      String :name
      String :region, fixed: true, size: 2
    end

    db.create_table :sales_reps do
      primary_key :id
      String :name
    end

    db.create_table :products do
      primary_key :id
      String :description
      Float :price
    end

    db.create_table :orders do
      primary_key :id
      foreign_key :customer_id, :customers
      foreign_key :sales_rep_id, :sales_reps
      foreign_key :product_id, :products
      Integer :quantity
      Date :order_date
    end

    # Use a generated column for `year`.
    db.run(
      "alter table orders add column year numeric " \
      "generated always as (extract ('year' from order_date)) stored"
    )
  end

  def seed_database(db)
    products = db.from('products')
    product_ids = 1.upto(NUM_PRODUCTS).map do
      products.insert(
        description: "#{Faker::Appliance.brand} #{Faker::Appliance.equipment}",
        price: rand(1..100)
      )
    end

    customers = db.from('customers')
    customer_ids= 1.upto(NUM_CUSTOMERS).map do
      customers.insert(
        name: Faker::Name.name,
        region: Faker::Address.state_abbr
      )
    end

    sales_reps = db.from('sales_reps')
    sales_rep_ids = 1.upto(NUM_SALES_REPS).map do
      sales_reps.insert(
        name: Faker::Name.name
      )
    end

    orders = db.from('orders')
    order_ids = 1.upto(1000).map do
      product_id, customer_id, sales_rep_id = [product_ids, customer_ids, sales_rep_ids].map(&:sample)
      order_date = Faker::Date.between(from: '2014-09-23', to: '2021-03-01')
      orders.insert(
        quantity: rand(1..50),
        order_date: order_date,
        product_id: product_id,
        customer_id: customer_id,
        sales_rep_id: sales_rep_id
      )
    end
  end
end

GenDemoData.run
