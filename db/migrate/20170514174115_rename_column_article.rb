class RenameColumnArticle < ActiveRecord::Migration[5.0]
  def change
      rename_column :events, :article_qualis_a1, :artigos_qualis_a1
      rename_column :events, :article_qualis_a2, :artigos_qualis_a2
      rename_column :events, :article_qualis_b1, :artigos_qualis_b1
      rename_column :events, :article_qualis_b2, :artigos_qualis_b2
      rename_column :events, :article_qualis_b3, :artigos_qualis_b3
      rename_column :events, :article_qualis_b4, :artigos_qualis_b4
      rename_column :events, :article_qualis_b5, :artigos_qualis_b5
      rename_column :events, :article_qualis_c , :artigos_qualis_c 
  end
end
