class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string  :num_code, :null => false
      t.string  :char_code, :null => false
      t.string  :name, :null => false
      t.boolean :basic, :default => false
      t.string  :locale
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end

# <Valute ID="R01235">
# 	<NumCode>840</NumCode>
# 	<CharCode>USD</CharCode>
# 	<Nominal>1</Nominal>
# 	<Name>Доллар США</Name>
# 	<Value>30,8612</Value>
# </Valute>
