class AddTrackToUser < ActiveRecord::Migration
  def change
    add_column :users, :track, "ENUM('dev', 'qa')"
  end
end
