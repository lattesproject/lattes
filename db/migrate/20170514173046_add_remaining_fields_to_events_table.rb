class AddRemainingFieldsToEventsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :artigos_qualis_a1_max, :float
    add_column :events, :artigos_qualis_a2_max, :float
    add_column :events, :artigos_qualis_b1_max, :float
    add_column :events, :artigos_qualis_b2_max, :float
    add_column :events, :artigos_qualis_b3_max, :float
    add_column :events, :artigos_qualis_b4_max, :float
    add_column :events, :artigos_qualis_b5_max, :float
    add_column :events, :artigos_qualis_c_max, :float
    
    add_column :events, :livros, :float
    add_column :events, :livros_max, :float
    
    add_column :events, :capitulos_de_livros, :float
    add_column :events, :capitulos_de_livros_max, :float
    
    add_column :events, :projetos_de_pesquisa, :float
    add_column :events, :projetos_de_pesquisa_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_a1, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_a1_max, :float
    
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_a2, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_a2_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b1, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b1_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b2, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b2_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b3, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b3_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b4, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b4_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b5, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_b5_max, :float

    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_c, :float
    add_column :events, :trabalhos_completos_em_anais_de_congresso_qualis_c_max, :float
    
    add_column :events, :resumos_em_anais_de_congresso_qualis_a1, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_a1_max, :float

    add_column :events, :resumos_em_anais_de_congresso_qualis_a2, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_a2_max, :float

    add_column :events, :resumos_em_anais_de_congresso_qualis_b1, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_b1_max, :float

    add_column :events, :resumos_em_anais_de_congresso_qualis_b2, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_b2_max, :float

    add_column :events, :resumos_em_anais_de_congresso_qualis_b3, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_b3_max, :float

    add_column :events, :resumos_em_anais_de_congresso_qualis_b4, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_b4_max, :float

    add_column :events, :resumos_em_anais_de_congresso_qualis_c, :float
    add_column :events, :resumos_em_anais_de_congresso_qualis_c_max, :float

    add_column :events, :bancas_graduacao, :float
    add_column :events, :bancas_graduacao_max, :float

    add_column :events, :bancas_mestrado, :float
    add_column :events, :bancas_mestrado_max, :float

    add_column :events, :bancas_doutorado, :float
    add_column :events, :bancas_doutorado_max, :float

    add_column :events, :bancas_especializacao, :float
    add_column :events, :bancas_especializacao_max, :float

    add_column :events, :orientacoes_mestrado, :float
    add_column :events, :orientacoes_mestrado_max, :float

    add_column :events, :orientacoes_doutorado, :float
    add_column :events, :orientacoes_doutorado_max, :float

    add_column :events, :orientacoes_outras, :float
    add_column :events, :orientacoes_outras_max, :float
  end
end