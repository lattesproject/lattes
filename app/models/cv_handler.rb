require "json"
require 'active_support/all'
require 'nokogiri'

class CvHandler

	def convert_xml_json(xml)
		json = Hash.from_xml(xml).to_json
		JSON.parse(json)
	end
end