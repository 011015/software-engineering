class CreateAudios < ActiveRecord::Migration[7.0]
  def change
    create_table :audios do |t|
      t.string :音频
      t.string :属性
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end
  end
end
