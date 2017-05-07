class AddEventName < ActiveRecord::Migration[5.0]
  def change
  	add_column :events, :event_name, :string
  end
end
