class AddTrackToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :track, "ENUM('dev', 'qa')"
  end
end
