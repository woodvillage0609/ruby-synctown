class AddAttachmentPhotoToNotes < ActiveRecord::Migration
  def self.up
    change_table :notes do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :notes, :photo
  end
end
