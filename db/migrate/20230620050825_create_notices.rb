class CreateNotices < ActiveRecord::Migration[7.0]
  def change
    create_table :notices do |t|
      t.references :receiver, null: false, foreign_key: { to_table: :manipulators }
      t.string :sender
      t.string :path
      t.string :内容
      t.string :notification_type
      t.string :read_by_receiver
      # ?收藏了?的曲谱 / ?通过、驳回了?的举报 / ?删除了?的评论 / ?回复了?的评论 / ?举报了?的评论

      t.timestamps
    end
  end
end
