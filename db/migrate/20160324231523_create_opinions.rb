class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.text :body
      t.references :micropost, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
