class AddManipulatorToSong < ActiveRecord::Migration[7.0]
  def change
    add_reference :songs, :manipulator, foreign_key: true
  end
end
