require "json"
require 'active_support/all'
require 'nokogiri'

class CvHandler
	
	@json_cv
	@json_qualis
	@found_article_total_points
	@event
	@articles
	@books
	@book_caps
	@doctor_judgement_participation
	@master_judgement_participation
	@postgraduate_judgement_participation
	@graduation_judgement_participation
	@doctor_tutoring
	@master_tutoring
	@other_tutoring
	@projects
	
	def initialize(xml,event)
		@event = event
		@json_cv = convert_xml_json(xml)['CURRICULO_VITAE']
		@json_qualis =  File.read(get_file_periodico)
		@json_qualis = JSON.parse(@json_qualis)
		@found_article_total_points = 0.0

		@articles = @json_cv['PRODUCAO_BIBLIOGRAFICA']['ARTIGOS_PUBLICADOS']['ARTIGO_PUBLICADO']
		@books = @json_cv['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['LIVROS_PUBLICADOS_OU_ORGANIZADOS']['LIVRO_PUBLICADO_OU_ORGANIZADO']
		@book_caps = @json_cv['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['CAPITULOS_DE_LIVROS_PUBLICADOS']['CAPITULO_DE_LIVRO_PUBLICADO']
		@projects = @json_cv['DADOS_GERAIS']['ATUACOES_PROFISSIONAIS']['ATUACAO_PROFISSIONAL'][4]['ATIVIDADES_DE_PARTICIPACAO_EM_PROJETO']['PARTICIPACAO_EM_PROJETO']
		@doctor_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_DOUTORADO']
		@master_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_MESTRADO']
		@postgraduate_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_APERFEICOAMENTO_ESPECIALIZACAO']
		@graduation_judgement_participation = @json_cv['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_GRADUACAO']
		@master_tutoring = @json_cv['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_MESTRADO']
		@doctor_tutoring = @json_cv['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_DOUTORADO']
		@other_tutoring = @json_cv['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['OUTRAS_ORIENTACOES_CONCLUIDAS']
	end

	def get_file_periodico
		File.join(Rails.root, 'app', 'models/qualis', 'periodico.json')
	end

	def convert_xml_json(xml)
		json = Hash.from_xml(xml).to_json
		JSON.parse(json)
	end

	def get_articles_found_total_points
		get_articles_found.each do |article|
			@found_article_total_points = @found_article_total_points + qualis_point(article['qualis'])
		end
		@found_article_total_points
	end

	def get_articles_found
		article_array_found = Array.new
		@articles.each do |article|
			article_periodic = article['DETALHAMENTO_DO_ARTIGO']['TITULO_DO_PERIODICO_OU_REVISTA']

			if(@json_qualis["periodico"].has_key?(article_periodic))
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

			if(!@json_qualis["periodico"].has_key?(article_periodic))
				article_array_not_found.push article
			end
				
		end
		article_array_not_found
	end

	#remember to remove all the paramaters you don't need them anymore since you have access to the Events from here
	def get_book_total_points
		size = @books.length
		size = @event.livros_max if size > @event.livros_max
		size * @event.livros
	end

	def get_book_cap_total_points
		size = @book_caps.length
		size = @event.capitulos_de_livros_max if size > @event.capitulos_de_livros_max
		size * @event.capitulos_de_livros
	end

	def get_project_total_points
		size = 0
		@projects.each do |project|
			size = size + (project["PROJETO_DE_PESQUISA"].kind_of?(Hash) ? 1 : @postgraduate_judgement_participation.length)
		end

		size = @event.projetos_de_pesquisa_max if size > @event.projetos_de_pesquisa_max
		size * @event.projetos_de_pesquisa
	end

	def get_completed_work_in_congress_total_points
		completed_works = @json_cv['PRODUCAO_BIBLIOGRAFICA']['TRABALHOS_EM_EVENTOS']['TRABALHO_EM_EVENTOS'].select{|item| item['DADOS_BASICOS_DO_TRABALHO']['NATUREZA']==('COMPLETO')}
		size = completed_works.length
		size = max if size > max
		size * point_value
	end

	def get_summarized_work_in_congress_total_points
		@summarized_works = @json_cv['PRODUCAO_BIBLIOGRAFICA']['TRABALHOS_EM_EVENTOS']['TRABALHO_EM_EVENTOS'].select{|item| item['DADOS_BASICOS_DO_TRABALHO']['NATUREZA']==('RESUMO')}
		size = @summarized_works.length
		size = max if size > max
		@summarized_work_in_congress_total_points = size * point_value
	end

	def get_doctor_judgement_participation_points
		size = @doctor_judgement_participation.length
		size = @event.bancas_doutorado_max if size > @event.bancas_doutorado_max
		size * @event.bancas_doutorado
	end

	def get_master_judgement_participation_points
		size = @master_judgement_participation.length
		size = @event.bancas_mestrado_max if size > @event.bancas_mestrado_max
		size * @event.bancas_mestrado
	end

	def get_postgraduate_judgement_participation_points
		size = @postgraduate_judgement_participation.kind_of?(Hash) ? 1 : @postgraduate_judgement_participation.length
		size = @event.bancas_especializacao_max if size > @event.bancas_especializacao_max
		size * @event.bancas_especializacao
	end

	def get_graduation_judgement_participation_points
		size = @graduation_judgement_participation.length
		size = @event.bancas_graduacao_max if size > @event.bancas_graduacao_max
		size * @event.bancas_graduacao
	end

	def get_doctor_tutoring_points
		size = @doctor_tutoring.length
		size = @event.orientacoes_doutorado_max if size > @event.orientacoes_doutorado_max
		size * @event.orientacoes_doutorado
	end

	def get_master_tutoring_points
		size = @master_tutoring.length
		size = @event.orientacoes_mestrado_max if size > @event.orientacoes_mestrado_max
		size * @event.orientacoes_mestrado
	end

	def get_other_tutoring_points
		size = @other_tutoring.length
		size = @event.orientacoes_outras_max if size > @event.orientacoes_outras_max
		size * @event.orientacoes_outras
	end

	def qualis_point(qualis)
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

	def get_books
		@books
	end

	def get_book_caps
		@book_caps
	end

	def get_doctor_judgement_participation
		@doctor_judgement_participation
	end

	def get_master_judgement_participation
		@master_judgement_participation
	end

	def get_postgraduate_judgement_participation
		return [@postgraduate_judgement_participation] if @postgraduate_judgement_participation.kind_of?(Hash)
		@postgraduate_judgement_participation
	end

	def get_graduation_judgement_participation
		@graduation_judgement_participation
	end

	def get_doctor_tutoring
		return [@doctor_tutoring] if @doctor_tutoring.kind_of?(Hash)
		@doctor_tutoring
	end

	def get_master_tutoring
		@master_tutoring
	end

	def get_other_tutoring
		@other_tutoring
	end

	def get_projects
		projects_obtained = Array.new
		@projects.each do |project|
			projects_obtained = projects_obtained + (project["PROJETO_DE_PESQUISA"].kind_of?(Hash) ? [project["PROJETO_DE_PESQUISA"]] : project["PROJETO_DE_PESQUISA"])
		end
		projects_obtained
	end

end