class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :图片
      t.string :属性
      t.references :song, foreign_key: true

      t.timestamps
    end
  end
end
