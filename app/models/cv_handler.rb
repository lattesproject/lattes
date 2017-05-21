require "json"
require 'active_support/all'
require 'nokogiri'

class CvHandler

	def convert_xml_json
		xml  = File.read("C:/Users/Bruno Souza/lattes_project/tmp/curriculo.xml")
		json = Hash.from_xml(xml).to_json
	end
end