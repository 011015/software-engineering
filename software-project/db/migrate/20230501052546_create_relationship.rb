class CreateRelationship < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.references :song, foreign_key: true
      t.references :song_type, foreign_key: true

      t.timestamps
    end
  end
end
