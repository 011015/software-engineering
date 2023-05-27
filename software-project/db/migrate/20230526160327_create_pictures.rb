class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures do |t|
      t.string :图片
      t.references :song, foreign_key: true
      t.references :manipulator, foreign_key: true

      t.timestamps
    end
  end
end
