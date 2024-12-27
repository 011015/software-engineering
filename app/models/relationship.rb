class Relationship < ApplicationRecord
    belongs_to :song, optional: true
    belongs_to :song_type, optional: true
end
