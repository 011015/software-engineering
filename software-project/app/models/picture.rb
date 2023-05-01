class Picture < ApplicationRecord
  belongs_to :manipulator, optional: true
end
