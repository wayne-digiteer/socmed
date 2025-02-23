class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.boolean :active
      t.boolean :featured
      t.datetime :published_date
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
