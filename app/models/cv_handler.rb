require "json"
require 'active_support/all'
require 'nokogiri'

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
			found_article_total_points = found_article_total_points + qualis_point(article['qualis'])
		end
		found_article_total_points
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
				article.store("suggestions", get_suggestions(article_periodic))
				article_array_not_found.push article
			end
				
		end
		article_array_not_found
	end

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
		found_completed_work_total_points = 0
		get_completed_work_in_congress_found.each do |completed_work|
			found_completed_work_total_points = found_completed_work_total_points + qualis_point(completed_work['qualis'])
		end
		found_completed_work_total_points
	end

	def get_completed_work_in_congress_found
		completed_work_in_congress_array_found = Array.new
		@completed_works.each do |completed_work|
			completed_work_periodic = completed_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(@json_qualis["periodico"].has_key?(completed_work_periodic))
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

			if(!@json_qualis["periodico"].has_key?(completed_work_periodic))
				completed_work_in_congress_array_not_found.push completed_work
			end
		end
		completed_work_in_congress_array_not_found
	end

	def get_summarized_work_in_congress_found
		summarized_work_in_congress_found = Array.new
		@summarized_works.each do |summarized_work|
			summarized_work_periodic = summarized_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(@json_qualis["periodico"].has_key?(summarized_work_periodic))
				summarized_work.store('qualis',@json_qualis["periodico"][summarized_work_periodic])
				summarized_work_in_congress_found.push summarized_work
			end
		end
		summarized_work_in_congress_found
	end

	def get_summarized_work_in_congress_total_points
		summarized_work_in_congress_total_points = 0
		get_summarized_work_in_congress_found.each do |summarized_work|
			summarized_work_in_congress_total_points = summarized_work_in_congress_total_points + qualis_point(summarized_work['qualis'])
		end
		summarized_work_in_congress_total_points
	end

	def get_summarized_work_in_congress_not_found
		summarized_work_in_congress_found = Array.new
		@summarized_works.each do |summarized_work|
			summarized_work_periodic = summarized_work['DETALHAMENTO_DO_TRABALHO']['TITULO_DOS_ANAIS_OU_PROCEEDINGS']

			if(!@json_qualis["periodico"].has_key?(summarized_work_periodic))
				summarized_work_in_congress_found.push summarized_work
			end
		end
		summarized_work_in_congress_found
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

	def get_books
		return [@books] if @books.kind_of?(Hash)
		@books
	end

	def get_book_caps
		return [@book_caps] if @book_caps.kind_of?(Hash)
		@book_caps
	end

	def get_doctor_judgement_participation
		return [@doctor_judgement_participation] if @doctor_judgement_participation.kind_of?(Hash)
		@doctor_judgement_participation
	end

	def get_master_judgement_participation
		return [@master_judgement_participation] if @master_judgement_participation.kind_of?(Hash)
		@master_judgement_participation
	end

	def get_postgraduate_judgement_participation
		return [@postgraduate_judgement_participation] if @postgraduate_judgement_participation.kind_of?(Hash)
		@postgraduate_judgement_participation
	end

	def get_graduation_judgement_participation
		return [@graduation_judgement_participation] if @graduation_judgement_participation.kind_of?(Hash)
		@graduation_judgement_participation
	end

	def get_doctor_tutoring
		return [@doctor_tutoring] if @doctor_tutoring.kind_of?(Hash)
		@doctor_tutoring
	end

	def get_master_tutoring
		return [@master_tutoring] if @master_tutoring.kind_of?(Hash)
		@master_tutoring
	end

	def get_other_tutoring
		return [@other_tutoring] if @other_tutoring.kind_of?(Hash)
		@other_tutoring
	end

	def get_projects
		projects_obtained = Array.new
		@projects.each do |project|
			projects_obtained = projects_obtained + (project["PROJETO_DE_PESQUISA"].kind_of?(Hash) ? [project["PROJETO_DE_PESQUISA"]] : project["PROJETO_DE_PESQUISA"])
		end
		projects_obtained
	end

	def get_name
		@name
	end

	def get_total
		get_articles_found_total_points + get_book_total_points + get_book_cap_total_points + get_project_total_points + get_doctor_judgement_participation_points + get_master_judgement_participation_points + get_postgraduate_judgement_participation_points + get_graduation_judgement_participation_points + get_doctor_tutoring_points + get_master_tutoring_points + get_other_tutoring_points
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


def get_suggestions(article_periodic)
    suggestions = Hash.new
    #puts "artigo => #{article_periodic}"
    @json_qualis["periodico"].each do |periodic, qualis|
      dif = levenshtein_distance(article_periodic, periodic)
      if dif < 27
        suggestions.store(periodic,{'qualis'=>qualis, 'dif'=> dif , 'value'=>qualis_point(qualis)})
      end
    end


    puts suggestions = Hash[suggestions.sort_by { |k, v| v['dif'] }[0..9]]
    return suggestions

  end

 def levenshtein_distance(s, t)
    m = s.length
    n = t.length
    return m if n == 0
    return n if m == 0
    d = Array.new(m+1) {Array.new(n+1)}

    (0..m).each {|i| d[i][0] = i}
    (0..n).each {|j| d[0][j] = j}
    (1..n).each do |j|
      (1..m).each do |i|
      d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
            d[i-1][j-1]       # no operation required
            else
            [ d[i-1][j]+1,    # deletion
              d[i][j-1]+1,    # insertion
              d[i-1][j-1]+1,  # substitution
            ].min
            end
      end
    end
    d[m][n]
  end

end