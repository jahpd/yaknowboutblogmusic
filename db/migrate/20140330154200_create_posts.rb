class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :author
      t.string :title
      t.text :doc
      t.text :code

      t.timestamps
    end
  end
end
