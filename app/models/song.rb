class Song < ApplicationRecord
    belongs_to :manipulator
    has_many :relationships, dependent: :nullify
    has_many :song_types, through: :relationships, dependent: :nullify
    has_one :封面, class_name: "Picture", dependent: :destroy   # 封面
    has_many :comments, dependent: :destroy
    has_many :reports, dependent: :destroy
    has_many :collects, dependent: :destroy
    has_many :images, dependent: :destroy    # 曲谱图片
    has_one :audio, dependent: :destroy
end
