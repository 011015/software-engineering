class Image < ApplicationRecord
  belongs_to :song, optional: true
end
