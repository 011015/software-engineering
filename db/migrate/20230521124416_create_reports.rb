class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :内容
      t.string :状态
      t.string :message
      t.references :comment, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.references :manipulator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
