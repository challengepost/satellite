class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, [:uid, :provider], unique: true
  end
end
