class CreateNoteShares < ActiveRecord::Migration[5.1]
  def change
    create_table :note_shares do |t|
      t.references :note
      t.references :user
      t.string :access_role
      t.integer :creator_id

      t.timestamps
    end
  end
end
