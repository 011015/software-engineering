class Audio < ApplicationRecord
  belongs_to :song, optional: true
end
