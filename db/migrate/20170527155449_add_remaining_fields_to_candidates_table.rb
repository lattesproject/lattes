class AddRemainingFieldsToCandidatesTable < ActiveRecord::Migration[5.0]
  def change
  		add_column :candidates, :user_id, :integer
  		add_column :candidates, :event_id, :integer
  	    add_column :candidates, :nome, :string
  	    add_column :candidates, :total_geral, :float
  end
end
