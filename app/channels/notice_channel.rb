class NoticeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "user_#{params[:receiver_id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
