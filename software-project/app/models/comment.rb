class Comment < ApplicationRecord
  belongs_to :song
  belongs_to :manipulator
  has_many :reports, dependent: :destroy
end
