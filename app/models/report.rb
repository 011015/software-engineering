class Report < ApplicationRecord
  belongs_to :comment, optional: true
  belongs_to :song
  belongs_to :manipulator
end
