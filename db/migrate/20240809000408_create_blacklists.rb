class CreateBlacklists < ActiveRecord::Migration[7.1]
  def change
    create_table :blacklists do |t|
      t.string :token

      t.timestamps
    end
  end
end
