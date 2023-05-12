class Song < ApplicationRecord
    belongs_to :manipulator
    has_many :relationships, dependent: :nullify
    has_many :song_types, through: :relationships, dependent: :nullify
    has_many :pictures, dependent: :delete_all
end
