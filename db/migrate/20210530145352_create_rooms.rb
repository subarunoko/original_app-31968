class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.text :name
      t.timestamps
    end
  end
end
