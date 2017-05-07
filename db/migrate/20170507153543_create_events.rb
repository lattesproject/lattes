class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
    	t.float :article_qualis_a1
		t.float :article_qualis_a2
		t.float :article_qualis_b1
		t.float :article_qualis_b2
		t.float :article_qualis_b3
		t.float :article_qualis_b4
		t.float :article_qualis_b5
		t.float :article_qualis_c
		t.timestamps
    end
  end
end
