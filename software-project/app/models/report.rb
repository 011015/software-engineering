class Report < ApplicationRecord
  belongs_to :comment, optional: true
  belongs_to :manipulator
end
