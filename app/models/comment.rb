class Comment < ApplicationRecord
  belongs_to :song, optional: true
  belongs_to :manipulator
  belongs_to :parent_comment, class_name: "Comment", foreign_key: "reply_id",  optional: true
  has_many :child_comments, class_name: "Comment", foreign_key: "reply_id", dependent: :destroy
  has_many :reports

  # scope :pending, -> { where(状态: '待审核') }
  # scope :approved_or_rejected, -> { where(状态: ['已通过', '已驳回']) }

  # before_destroy :delete_child_comments_recursively

  before_destroy :handle_reports
  # after_destroy :nullify_reports_with_status_approved_or_rejected

  private
  # def delete_child_comments_recursively
  #   child_comments.each do |child_comment|
  #     child_comment.destroy
  #   end
  # end

  def handle_reports
    reports.each do |report|
      if report.状态 == '待审核'
        report.destroy
      else
        msg = report.comment.内容
        report.update(comment_id: nil, message: msg)
      end
    end
  end

  # def nullify_reports_with_status_approved_or_rejected
  #   reports.approved_or_rejected.update_all(comment_id: nil)
  # end
end
