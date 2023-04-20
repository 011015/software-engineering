class Manipulator < ApplicationRecord
    has_one :头像, class_name: "Picture", dependent: :destroy
end
