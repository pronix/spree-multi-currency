# encoding: utf-8

class CreateCurrencyConverters < ActiveRecord::Migration
  def self.up
    create_table :spree_currency_converters do |t|
      t.integer  :currency_id, :null => false
      t.datetime :date_req, :null => false
      t.float    :nominal, :null => false, :default => 1
      t.float    :value, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :spree_currency_converters
  end
end
