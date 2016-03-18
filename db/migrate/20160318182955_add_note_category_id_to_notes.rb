class AddNoteCategoryIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :note_category_id, :integer
  end
end
