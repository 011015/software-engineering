class Picture < ApplicationRecord
    belongs_to :manipulator, optional: true
    belongs_to :song, optional: true
end
  