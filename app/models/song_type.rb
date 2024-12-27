class SongType < ApplicationRecord
    has_many :relationships, dependent: :nullify
    has_many :songs, through: :relationships, dependent: :nullify
end
