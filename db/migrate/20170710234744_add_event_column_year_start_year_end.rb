class AddEventColumnYearStartYearEnd < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :start_year, :integer, null: false, default: 0
    add_column :events, :end_year, :integer, null: false, default: 0
  end
end