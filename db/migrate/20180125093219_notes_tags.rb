class NotesTags < ActiveRecord::Migration[5.1]
  def change
    create_table :notes_tags, id: false do |t|
      t.references :tag, foreign_key: true
      t.references :note, foreign_key: true

      t.timestamps
    end
  end
end
