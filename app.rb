require 'bundler'
Bundler.require

require 'json'
require "nokogiri"
require "open-uri"
require "google_drive"
require 'csv'
require 'dotenv'


$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'


new_mairie = Scrapper.new('http://annuaire-des-mairies.com/val-d-oise.html')
 
new_mairie.save_as_JSON

new_mairie.save_as_spreadsheet

new_mairie.save_as_csv



