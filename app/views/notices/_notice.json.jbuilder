json.extract! notice, :id, :sender_id, :receiver_id, :notifiable_obj_id, :notification_type, :read_by_sender, :read_by_receiver, :created_at, :updated_at
json.url notice_url(notice, format: :json)
