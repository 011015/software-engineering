json.extract! report, :id, :内容, :状态, :comment_id, :manipulator_id, :created_at, :updated_at
json.url report_url(report, format: :json)
