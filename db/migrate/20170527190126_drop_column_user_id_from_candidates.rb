class DropColumnUserIdFromCandidates < ActiveRecord::Migration[5.0]
  def change
  	remove_column :candidates, :user_id
  end
end
