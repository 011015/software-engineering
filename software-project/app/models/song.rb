class Song < ApplicationRecord
    belongs_to :manipulator
    has_many :relationships, dependent: :nullify
    has_many :song_types, through: :relationships, dependent: :nullify
    has_one :封面, class_name: "Picture", dependent: :destroy   # 封面
    has_many :comments, dependent: :delete_all
    has_many :collects, dependent: :delete_all
    has_many :images, dependent: :delete_all    # 曲谱图片
end
