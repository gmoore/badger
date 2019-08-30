class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :description
      t.string :large_image_url
      t.string :small_image_url
      t.string :created_by
      t.string :group
      t.timestamps
    end
  end
end
