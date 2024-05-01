class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :f_name
      t.string :l_name
      t.string :email
      t.string :address
      t.string :password_digest

      t.timestamps
    end
  end
end
