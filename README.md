# HasUuid

Provides facilities to utilize UUIDs with ActiveRecord, including model and migration extensions.


## Installation

Add this line to your application's Gemfile:

    gem 'has_uuid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_uuid


## Usage

In a migration:

    create_table "comments", :id => false, :force => true do |t|
      t.uuid     "id",      :primary_key => true 
      t.uuid     "post_id",                       :null => false
    end

In a model:

    class Posts < ActiveRecord::Base
      include WithUuid::Model

      # ...
    end
