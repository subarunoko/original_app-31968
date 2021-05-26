class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string  :description
      t.string  :language_id, null:false
      t.references :user
      t.timestamps
    end
  end
end
