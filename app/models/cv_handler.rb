require "json"
require 'active_support/all'
require 'nokogiri'
require 'symspell'

class CvHandler
		
	def initialize(xml,event)
		@event = event
		@json_cv = convert_xml_json(xml)['CURRICULO_VITAE']
		@json_qualis =  File.read(get_file_periodico)
		@json_qualis = JSON.parse(@json_qualis)
		@found_article_total_points = 0.0
		@name = @json_cv['DADOS_GERAIS']['NOME_COMPLETO']
		@articles = @json_cv['PRODUCAO_BIBLIOGRAFICA']['ARTIGOS_PUBLICADOS']['ARTIGO_PUBLICADO'] || [] rescue []
		@books = @json_cv['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['LIVROS_PUBLICADOS_OU_ORGANIZADOS']['LIVRO_PUBLICADO_OU_ORGANIZADO'] || [] rescue []
		@book_caps = @json_cv['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['CAPITULOS_DE_LIVROS_PUBLICADOS']['CAPITULO_DE_LIVRO_PUBLICADO'] || [] rescue []
		@projects = @json_cv['DADOS_GERAIS']['ATUACOES_PROFISSIONAIS']['ATUACAO_PROFISSIONAL'][4]['ATIVIDADES_DE_PARTICIPACAO_EM_PROJETO']['PARTICIPACAO_EM_PROJETO'] || [] rescue []
		@completed_works = @json_cv['PRODUCAO_BIBLIOGRAFICA']['TRABALHOS_EM_EVENTOS']['TRABALHO_EM_EVENTOS'].select{|item| item['DADOS_BASICOS_DO_TRABALHO']['NATUREZA']==('COMPLETO')} || [] rescue []
		@summarized_works = @json_cv['PRODUCAO_BIBLIOGRAFICA']['TRABALHOS_EM_EVENTOS']['TRABALHO_EM_EVENTOS'].select{|item| item['DADOS_BASICOS_DO_TRABALHO']['NATUREZA']==('RESUMO')}  || [] rescue []
		@doctor_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_DOUTORADO'] || [] rescue []
		@master_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_MESTRADO'] || [] rescue []
		@postgraduate_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_APERFEICOAMENTO_ESPECIALIZACAO'] || [] rescue []
		@graduation_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_GRADUACAO'] || [] rescue []
		@master_tutoring = @json_cv['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_MESTRADO'] || [] rescue []
		@doctor_tutoring = @json_cv['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_DOUTORADO'] || [] rescue []
		@other_tutoring = @json_cv['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['OUTRAS_ORIENTACOES_CONCLUIDAS'] || [] rescue []
	end

	def get_file_periodico
		File.join(Rails.root, 'app', 'models/qualis', 'periodico.json')
	end

	def convert_xml_json(xml)
		json = Hash.from_xml(xml).to_json
		JSON.parse(json)
	end

	def get_articles_found_total_points
		found_article_total_points = 0
		get_articles_found.each do |article|
			found_article_total_points = found_article_total_points + qualis_point_articles(article['qualis'])
		end
		found_article_total_points
	end

	def get_articles_found
		article_array_found = Array.new
		@articles.each do |article|
			article_periodic = article['DETALHAMENTO_DO_ARTIGO']['TITULO_DO_PERIODICO_OU_REVISTA']
			
			if(@json_qualis["periodico"].has_key?(article_periodic) && is_in_range?(article["DADOS_BASICOS_DO_ARTIGO"]["ANO_DO_ARTIGO"].to_i))
				article.store('qualis',@json_qualis["periodico"][article_periodic])
				article_array_found.push article
			end

		end
		article_array_found
	end

	def get_articles_not_found
		article_array_not_found = Array.new
		@articles.each do |article|
			article_periodic = article['DETALHAMENTO_DO_ARTIGO']['TITULO_DO_PERIODICO_OU_REVISTA']

			if(!@json_qualis["periodico"].has_key?(article_periodic) && is_in_range?(article["DADOS_BASICOS_DO_ARTIGO"]["ANO_DO_ARTIGO"].to_i))
				article_array_not_found.push article
			end
				
		end
		article_array_not_found
	end

	def get_book_total_points
		size = get_books.length
		size = @event.livros_max if size > @event.livros_max
		size * @event.livros
	end

	def get_book_cap_total_points
		size = get_book_caps.length
		size = @event.capitulos_de_livros_max if size > @event.capitulos_de_livros_max
		size * @event.capitulos_de_livros
	end

	def get_project_total_points
		size = get_projects.length
		size = @event.projetos_de_pesquisa_max if size > @event.projetos_de_pesquisa_max
		size * @event.projetos_de_pesquisa
	end

	def get_completed_work_in_congress_total_points
		found_completed_work_total_points = 0
		get_completed_work_in_congress_found.each do |completed_work|
			found_completed_work_total_points = found_completed_work_total_points + qualis_point_completed_work(completed_work['qualis'])
		end
		found_completed_work_total_points
	end

	def get_completed_work_in_congress_found
		completed_work_in_congress_array_found = Array.new
		@completed_works.each do |completed_work|
			completed_work_periodic = completed_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(@json_qualis["periodico"].has_key?(completed_work_periodic) && is_in_range?(completed_work['DADOS_BASICOS_DO_TRABALHO']["ANO_DO_TRABALHO"].to_i))  
				completed_work.store('qualis',@json_qualis["periodico"][completed_work_periodic])
				completed_work_in_congress_array_found.push completed_work
			end
		end
		completed_work_in_congress_array_found
	end

	def get_completed_work_in_congress_not_found
		completed_work_in_congress_array_not_found = Array.new
		@completed_works.each do |completed_work|
			completed_work_periodic = completed_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(!@json_qualis["periodico"].has_key?(completed_work_periodic) && is_in_range?(completed_work['DADOS_BASICOS_DO_TRABALHO']["ANO_DO_TRABALHO"].to_i))  
				completed_work_in_congress_array_not_found.push completed_work
			end
		end
		completed_work_in_congress_array_not_found
	end

	def get_completed_work_in_congress_not_found_2
		completed_work_in_congress_array_not_found = Array.new
		@completed_works.each do |completed_work|
			completed_work_periodic = completed_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(!@json_qualis["periodico"].has_key?(completed_work_periodic) && is_in_range?(completed_work['DADOS_BASICOS_DO_TRABALHO']["ANO_DO_TRABALHO"].to_i)) 
				completed_work_in_congress_array_not_found.push completed_work
			end
		end
		completed_work_in_congress_array_not_found
	end

	def get_summarized_work_in_congress_found
		summarized_work_in_congress_found = Array.new
		@summarized_works.each do |summarized_work|
			summarized_work_periodic = summarized_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(@json_qualis["periodico"].has_key?(summarized_work_periodic) && is_in_range?(summarized_work['DADOS_BASICOS_DO_TRABALHO']["ANO_DO_TRABALHO"].to_i))
				summarized_work.store('qualis',@json_qualis["periodico"][summarized_work_periodic])
				summarized_work_in_congress_found.push summarized_work
			end
		end
		summarized_work_in_congress_found
	end

	#needs to be checked
	def get_summarized_work_not_found
		summarized_work_not_found = Array.new
		@summarized_works.each do |summarized_work|
			summarized_work_anais = summarized_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(!@json_qualis["periodico"].has_key?(summarized_work_anais) && is_in_range?(summarized_work['DADOS_BASICOS_DO_TRABALHO']["ANO_DO_TRABALHO"].to_i))  
				summarized_work_not_found.push summarized_work
			end
				
		end
		summarized_work_not_found
	end

	def get_summarized_work_in_congress_total_points
		summarized_work_in_congress_total_points = 0
		get_summarized_work_in_congress_found.each do |summarized_work|
			summarized_work_in_congress_total_points = summarized_work_in_congress_total_points + qualis_point_summarized_work(summarized_work['qualis']) 
		end
		summarized_work_in_congress_total_points
	end

	def get_summarized_work_in_congress_not_found
		summarized_work_in_congress_found = Array.new
		@summarized_works.each do |summarized_work|
			summarized_work_periodic = summarized_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(!@json_qualis["periodico"].has_key?(summarized_work_periodic) && is_in_range?(summarized_work['DADOS_BASICOS_DO_TRABALHO']["ANO_DO_TRABALHO"].to_i))
				summarized_work_in_congress_found.push summarized_work
			end
		end
		summarized_work_in_congress_found
	end

	def get_doctor_judgement_participation_points
		size = get_doctor_judgement_participation.length
		size = @event.bancas_doutorado_max if size > @event.bancas_doutorado_max
		size * @event.bancas_doutorado
	end

	def get_master_judgement_participation_points
		size = get_master_judgement_participation.length
		size = @event.bancas_mestrado_max if size > @event.bancas_mestrado_max
		size * @event.bancas_mestrado
	end

	def get_postgraduate_judgement_participation_points
		size = get_postgraduate_judgement_participation.length
		size = @event.bancas_especializacao_max if size > @event.bancas_especializacao_max
		size * @event.bancas_especializacao
	end

	def get_graduation_judgement_participation_points
		size = get_graduation_judgement_participation.length
		size = @event.bancas_graduacao_max if size > @event.bancas_graduacao_max
		size * @event.bancas_graduacao
	end

	def get_doctor_tutoring_points
		size = get_doctor_tutoring.length
		size = @event.orientacoes_doutorado_max if size > @event.orientacoes_doutorado_max
		size * @event.orientacoes_doutorado
	end

	def get_master_tutoring_points
		size = get_master_tutoring.length
		size = @event.orientacoes_mestrado_max if size > @event.orientacoes_mestrado_max
		size * @event.orientacoes_mestrado
	end

	def get_other_tutoring_points
		size = get_other_tutoring.length
		size = @event.orientacoes_outras_max if size > @event.orientacoes_outras_max
		size * @event.orientacoes_outras
	end

	def get_books
		@books = [@books] if @books.kind_of?(Hash)
		@books = @books.select {|book| (is_in_range?(book["DADOS_BASICOS_DO_LIVRO"]["ANO"].to_i))} || []
	end

	def get_book_caps
		@book_caps = [@book_caps] if @book_caps.kind_of?(Hash)
		@book_caps = @book_caps.select {|book_caps| (is_in_range?(book_caps["DADOS_BASICOS_DO_CAPITULO"]["ANO"].to_i))} || []
	end

	def get_doctor_judgement_participation
		@doctor_judgement_participation = [@doctor_judgement_participation] if @doctor_judgement_participation.kind_of?(Hash)
		@doctor_judgement_participation = @doctor_judgement_participation.select {|judgement| (is_in_range?(judgement["DADOS_BASICOS_DA_PARTICIPACAO_EM_BANCA_DE_DOUTORADO"]["ANO"].to_i))} || []
	end

	def get_master_judgement_participation
		@master_judgement_participation = [@master_judgement_participation] if @master_judgement_participation.kind_of?(Hash)
		@master_judgement_participation = @master_judgement_participation.select {|judgement| (is_in_range?(judgement["DADOS_BASICOS_DA_PARTICIPACAO_EM_BANCA_DE_MESTRADO"]["ANO"].to_i))} || []
	end

	def get_postgraduate_judgement_participation
		@postgraduate_judgement_participation = [@postgraduate_judgement_participation] if @postgraduate_judgement_participation.kind_of?(Hash)
		@postgraduate_judgement_participation = @postgraduate_judgement_participation.select {|judgement| (is_in_range?(judgement["DADOS_BASICOS_DA_PARTICIPACAO_EM_BANCA_DE_APERFEICOAMENTO_ESPECIALIZACAO"]["ANO"].to_i))} || []
	end

	def get_graduation_judgement_participation
		@graduation_judgement_participation = [@graduation_judgement_participation] if @graduation_judgement_participation.kind_of?(Hash)
		@graduation_judgement_participation = @graduation_judgement_participation.select {|judgement| (is_in_range?(judgement["DADOS_BASICOS_DA_PARTICIPACAO_EM_BANCA_DE_GRADUACAO"]["ANO"].to_i))} || []
	end

	def get_doctor_tutoring
		@doctor_tutoring = [@doctor_tutoring] if @doctor_tutoring.kind_of?(Hash)
		@doctor_tutoring = @doctor_tutoring.select {|tutoring| (is_in_range?(tutoring["DADOS_BASICOS_DE_ORIENTACOES_CONCLUIDAS_PARA_DOUTORADO"]["ANO"].to_i))} || []
	end

	def get_master_tutoring
		@master_tutoring = [@master_tutoring] if @master_tutoring.kind_of?(Hash)
		@master_tutoring = @master_tutoring.select {|tutoring| (is_in_range?(tutoring["DADOS_BASICOS_DE_ORIENTACOES_CONCLUIDAS_PARA_MESTRADO"]["ANO"].to_i))} || []
	end

	def get_other_tutoring
		@other_tutoring = [@other_tutoring] if @other_tutoring.kind_of?(Hash)
		@other_tutoring = @other_tutoring.select {|tutoring| (is_in_range?(tutoring["DADOS_BASICOS_DE_OUTRAS_ORIENTACOES_CONCLUIDAS"]["ANO"].to_i))} || []
	end

	def get_projects
		projects_obtained = Array.new
		@projects.each do |project|
			projects_obtained = projects_obtained + (project["PROJETO_DE_PESQUISA"].kind_of?(Hash) ? [project["PROJETO_DE_PESQUISA"]] : project["PROJETO_DE_PESQUISA"])
		end
		projects_obtained = projects_obtained.select {|project| (project["SITUACAO"] == "CONCLUIDO" && is_in_range?(project["ANO_FIM"].to_i))} || []
	end

	def get_name
		@name
	end

	def get_total
		get_articles_found_total_points + get_book_total_points + get_book_cap_total_points + get_project_total_points + get_doctor_judgement_participation_points + get_master_judgement_participation_points + get_postgraduate_judgement_participation_points + get_graduation_judgement_participation_points + get_doctor_tutoring_points + get_master_tutoring_points + get_other_tutoring_points
	end

	def qualis_point_articles(qualis)
		case qualis
		when 'A1'
			return @event.artigos_qualis_a1
		when 'A2'
			return @event.artigos_qualis_a2
		when 'B1'
			return @event.artigos_qualis_b1
		when 'B2'
			return @event.artigos_qualis_b2
		when 'B3'
			return @event.artigos_qualis_b3
		when 'B4'
			return @event.artigos_qualis_b4
		when 'B5'
			return @event.artigos_qualis_b5
		when 'C'
			return @event.artigos_qualis_c
		end
	end

	def qualis_point_summarized_work(qualis)
		case qualis
		when 'A1'
			return @event.resumos_em_anais_de_congresso_qualis_a1
		when 'A2'
			return @event.resumos_em_anais_de_congresso_qualis_a2
		when 'B1'
			return @event.resumos_em_anais_de_congresso_qualis_b1
		when 'B2'
			return @event.resumos_em_anais_de_congresso_qualis_b2
		when 'B3'
			return @event.resumos_em_anais_de_congresso_qualis_b3
		when 'B4'
			return @event.resumos_em_anais_de_congresso_qualis_b4
		when 'B5'
			return @event.resumos_em_anais_de_congresso_qualis_b5
		when 'C'
			return @event.resumos_em_anais_de_congresso_qualis_c
		end
	end

	def qualis_point_completed_work(qualis)
		case qualis
		when 'A1'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_a1
		when 'A2'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_a2
		when 'B1'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_b1
		when 'B2'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_b2
		when 'B3'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_b3
		when 'B4'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_b4
		when 'B5'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_b5
		when 'C'
			return @event.trabalhos_completos_em_anais_de_congresso_qualis_c
		end
	end
  
  def is_in_range?(year)
	 (year > @event.start_year && year < @event.end_year)
  end

end