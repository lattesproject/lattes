class Event < ActiveRecord::Base
	before_save :default_values
	belongs_to :user
	has_many :candidates
	validates :user_id, presence: true
	validates :event_name, presence: true,
	uniqueness: { case_sensitive: false },
	length: { minimum: 3, maximum: 25 }


  def default_values
  	self.artigos_qualis_a1 ||= 0.0
    self.artigos_qualis_a2 ||= 0.0
    self.artigos_qualis_b1 ||= 0.0
    self.artigos_qualis_b2 ||= 0.0
    self.artigos_qualis_b3 ||= 0.0
    self.artigos_qualis_b4 ||= 0.0
    self.artigos_qualis_b5 ||= 0.0
    self.artigos_qualis_c ||= 0.0
    self.artigos_qualis_a1_max ||= 0.0
    self.artigos_qualis_a2_max ||= 0.0
    self.artigos_qualis_b1_max ||= 0.0
    self.artigos_qualis_b2_max ||= 0.0
    self.artigos_qualis_b3_max ||= 0.0
    self.artigos_qualis_b4_max ||= 0.0
    self.artigos_qualis_b5_max ||= 0.0
    self.artigos_qualis_c_max ||= 0.0
    self.livros ||= 0.0
    self.livros_max ||= 0.0
    self.capitulos_de_livros ||= 0.0
    self.capitulos_de_livros_max ||= 0.0
    self.projetos_de_pesquisa ||= 0.0
    self.projetos_de_pesquisa_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_a1 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_a1_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_a2 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_a2_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b1 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b1_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b2 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b2_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b3 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b3_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b4 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b4_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b5 ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_b5_max ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_c ||= 0.0
    self.trabalhos_completos_em_anais_de_congresso_qualis_c_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_a1 ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_a1_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_a2 ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_a2_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b1 ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b1_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b2 ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b2_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b3 ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b3_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b4 ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_b4_max ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_c ||= 0.0
    self.resumos_em_anais_de_congresso_qualis_c_max ||= 0.0
    self.bancas_graduacao ||= 0.0
    self.bancas_graduacao_max ||= 0.0
    self.bancas_mestrado ||= 0.0
    self.bancas_mestrado_max ||= 0.0
    self.bancas_doutorado ||= 0.0
    self.bancas_doutorado_max ||= 0.0
    self.bancas_especializacao ||= 0.0
    self.bancas_especializacao_max ||= 0.0
    self.orientacoes_mestrado ||= 0.0
    self.orientacoes_mestrado_max ||= 0.0
    self.orientacoes_doutorado ||= 0.0
    self.orientacoes_doutorado_max ||= 0.0
    self.orientacoes_outras ||= 0.0
    self.orientacoes_outras_max ||= 0.0
 
  end

end




