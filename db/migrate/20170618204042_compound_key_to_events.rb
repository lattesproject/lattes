class CompoundKeyToEvents < ActiveRecord::Migration[5.0]
  def change
  	add_index :events, ["event_name", "user_id"], :unique => true
  end
end
