class Manipulator < ApplicationRecord
    has_one :头像, class_name: "Picture", dependent: :destroy
    has_many :songs, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :reports, dependent: :destroy
    has_many :collects, dependent: :destroy

    has_many :notices, dependent: :delete_all, class_name: "Notice", foreign_key: "receiver_id"
end
