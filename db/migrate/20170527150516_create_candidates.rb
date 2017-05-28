class CreateCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
    	t.float :article_qualis_a1_total
		t.float :article_qualis_a2_total
		t.float :article_qualis_b1_total
		t.float :article_qualis_b2_total
		t.float :article_qualis_b3_total
		t.float :article_qualis_b4_total
		t.float :article_qualis_b5_total
		t.float :article_qualis_c_total
		t.float :articles_total

        t.float :livros_total

    	t.float :capitulos_de_livros_total

	    t.float :projetos_de_pesquisa_total

	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_a1_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_a2_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_b1_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_b2_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_b3_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_b4_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_b5_total
	    t.float :trabalhos_completos_em_anais_de_congresso_qualis_c_total
	    t.float :trabalhos_completos_em_anais_de_congresso_total


	    t.float :resumos_em_anais_de_congresso_qualis_a1_total
	    t.float :resumos_em_anais_de_congresso_qualis_a2_total
	    t.float :resumos_em_anais_de_congresso_qualis_b1_total
	    t.float :resumos_em_anais_de_congresso_qualis_b2_total
	    t.float :resumos_em_anais_de_congresso_qualis_b3_total
	    t.float :resumos_em_anais_de_congresso_qualis_b4_total
	    t.float :resumos_em_anais_de_congresso_qualis_c_total
	    t.float :resumos_em_anais_de_congresso_total


	    t.float :bancas_graduacao_total
	    t.float :bancas_mestrado_total
	    t.float :bancas_doutorado_total
	    t.float :bancas_especializacao_total
	    t.float :bancas_total


	    t.float :orientacoes_mestrado_total
	    t.float :orientacoes_doutorado_total
	    t.float :orientacoes_outras_total
	    t.float :orientacoes_total
		t.timestamps
    end
  end
end
