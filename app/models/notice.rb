class Notice < ApplicationRecord
  belongs_to :receiver, class_name: "Manipulator"
end
