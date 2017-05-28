require "json"
require 'active_support/all'
require 'nokogiri'

class CvHandler

	@json_cv
	@books_total_points
	@book_cap_total_points	
	@project_total_points
	@completed_work_in_congress_total_points
	@summarized_work_in_congress_total_points
	@doctor_judgement_participation_points
	@master_judgement_participation_points
	@postgraduate_judgement_participation_points
	@graduation_judgement_participation_points
	@doctor_tutoring_points
	@master_tutoring_points
	@other_tutoring_points
	@article_array_found
	@article_array_not_found
	@json_qualis
	@found_article_total_points
	@event
	
	
	
	def initialize(xml,event)
		@event = event
		@json_cv = convert_xml_json(xml)
		@json_qualis =  File.read('C:\periodico.json')
		@json_qualis = JSON.parse(@json_qualis)
		@found_article_total_points=0.0
	end

	def convert_xml_json(xml)
		json = Hash.from_xml(xml).to_json
		JSON.parse(json)
	end


	def calculate_total_article_points	
		@json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['ARTIGOS_PUBLICADOS']['ARTIGO_PUBLICADO']
		@article_array_found = Array.new
		@article_array_not_found = Array.new
		@json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['ARTIGOS_PUBLICADOS']['ARTIGO_PUBLICADO'].each do |article|
			@article_periodic = article['DETALHAMENTO_DO_ARTIGO']['TITULO_DO_PERIODICO_OU_REVISTA']
			found = false;
			puts @article_periodic
			@json_qualis['data'].each do |periodic|
				
				if periodic.include? (" " + @article_periodic)
					found = true
					#article['qualis']=periodic[2]
					article.store('qualis',periodic[2])
					#puts qualis_point(periodic[2]).name.class + "HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEYYYYY"
					#puts @found_article_total_points.name.class
					@found_article_total_points = @found_article_total_points + qualis_point(periodic[2])

				end
			end

			if(found)
				@article_array_found.push article
			else
				@article_array_not_found.push article
			end
		end


		#{key=>'periodic_name', qualis=> 'qualis_category'}

		@found_article_total_points
		#status = @json_cv.fetch("data").fetch(@article_array[0])
	end

	#remember to remove all the paramaters you don't need them anymore since you have access to the Events from here
	def calculate_total_book_points
		@size = @json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['LIVROS_PUBLICADOS_OU_ORGANIZADOS']['LIVRO_PUBLICADO_OU_ORGANIZADO'].length
		@size = @event.livros_max if @size > @event.livros_max
		@books_total_points = @size*@event.livros
	end

	def get_book_total_points
		@books_total_points
	end

	def calculate_book_cap_total_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['CAPITULOS_DE_LIVROS_PUBLICADOS'].length
		@size = max if @size > max
		@book_cap_total_points = @size*point_value	
	end

	def get_book_cap_total_points
		@books_total_points
	end


	def calculate_project_total_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['DADOS_GERAIS']['ATUACOES_PROFISSIONAIS']['ATUACAO_PROFISSIONAL'][4]['ATIVIDADES_DE_PARTICIPACAO_EM_PROJETO']['PARTICIPACAO_EM_PROJETO'].length
		@size = max if @size > max
		@project_total_points = @size*point_value
	end

	def get_project_total_points
		@project_total_points
	end

	def calculate_completed_work_in_congress_total_points(point_value, max)
		@completed_works = @json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['TRABALHOS_EM_EVENTOS']['TRABALHO_EM_EVENTOS'].select{|item| item['DADOS_BASICOS_DO_TRABALHO']['NATUREZA']==('COMPLETO')}
		@size = @completed_works.length
		@size = max if @size > max
		@completed_work_in_congress_total_points = @size*point_value
	end

	def get_completed_work_in_congress_total_points
		@completed_work_in_congress_total_points
	end

	def calculate_summarized_work_in_congress_total_points(point_value, max)
		@summarized_works = @json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['TRABALHOS_EM_EVENTOS']['TRABALHO_EM_EVENTOS'].select{|item| item['DADOS_BASICOS_DO_TRABALHO']['NATUREZA']==('RESUMO')}
		@size = @summarized_works.length
		@size = max if @size > max
		@summarized_work_in_congress_total_points = @size*point_value
	end

	def get_summarized_work_in_congress_total_points
		@summarized_work_in_congress_total_points
	end

	def calculate_doctor_judgement_participation_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_DOUTORADO'].length
		@size = max if @size > max
		@doctor_judgement_participation_points = @size*point_value
	end

	def get_doctor_judgement_participation_point
		@doctor_judgement_participation_point
	end

	def calculate_master_judgement_participation_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_MESTRADO'].length
		@size = max if @size > max
		@master_judgement_participation_points = @size*point_value
	end

	def get_master_judgement_participation_points
		@master_judgement_participation_points
	end

	def calculate_postgraduate_judgement_participation_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_APERFEICOAMENTO_ESPECIALIZACAO'].length
		@size = max if @size > max
		@postgraduate_judgement_participation_points = @size*point_value
	end

	def get_postgraduate_judgement_participation_points
		@postgraduate_judgement_participation_points
	end

	def calculate_graduation_judgement_participation_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['DADOS_COMPLEMENTARES']['PARTICIPACAO_EM_BANCA_TRABALHOS_CONCLUSAO']['PARTICIPACAO_EM_BANCA_DE_GRADUACAO'].length
		@size = max if @size > max
		@graduation_judgement_participation_points = @size*point_value
	end

	def get_graduation_judgement_participation_points
		@graduation_judgement_participation_points
	end

	def calculate_doctor_tutoring_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_MESTRADO'].length
		@size = max if @size > max
		@doctor_tutoring_points = @size*point_value
	end

	def get_doctor_tutoring_points
		@doctor_tutoring_points
	end


	def calculate_master_tutoring_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_DOUTORADO'].length
		@size = max if @size > max
		@master_tutoring_points = @size*point_value
	end

	def get_master_tutoring_points
		@master_tutoring_points
	end

	def calculate_other_tutoring_points(point_value, max)
		@size = @json_cv['CURRICULO_VITAE']['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['OUTRAS_ORIENTACOES_CONCLUIDAS'].length
		@size = max if @size > max
		@other_tutoring_points = @size*point_value
	end

	def get_other_tutoring_points
		@other_tutoring_points
	end


	def get_books
		@size = @json_cv['CURRICULO_VITAE']['PRODUCAO_BIBLIOGRAFICA']['LIVROS_E_CAPITULOS']['LIVROS_PUBLICADOS_OU_ORGANIZADOS']['LIVRO_PUBLICADO_OU_ORGANIZADO']
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
		when 'C '
			return @event.artigos_qualis_c
		end
	end
end