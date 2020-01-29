class Scrapper
  attr_accessor :site , :data

  def initialize(site)
    @site = site
  end

  def scrapping_mairie 
    page = Nokogiri::HTML(open(@site))
    arr_cities = page.xpath('//tr/td/p/a/@href').map{ |c|  c.to_s.delete_prefix('./95/').delete_suffix(".html")}
    arr_sites = []
    arr_cities.each do |city|
      z = "http://annuaire-des-mairies.com/95/#{city}.html".to_s     
      arr_sites << z
    end
    arr_emails = []
    arr_sites.each do |new_site|
      x = Nokogiri::HTML(open(new_site))
      arr_emails << x.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]/text()").text
    end
    f = Hash[arr_cities.zip(arr_emails.map {|i| i})]
  end

  def save_as_JSON 
    @data = scrapping_mairie
    File.open("db/emails.json","w") do |f|
      f.write(JSON.pretty_generate(@data))
    end
  end

  def save_as_spreadsheet
    @data = scrapping_mairie
    session = GoogleDrive::Session.from_config(".env")
    ws = session.spreadsheet_by_key("1amJk00JLzqRtWz3eVfyE-WTw-YFjyEuanQ9IJZAttZA").worksheets[0]
    n = 1
    m = 1
    @data.values.each do |value|
      ws[n,2] = value
      n = n + 1
    end
    @data.keys.each do |key|
      ws[m,1] = key
      m = m + 1
    end
    ws.save
  end

  def save_as_csv
    @data = scrapping_mairie
    CSV.open("db/emails.csv", "wb") do |csv|
      @data.each do |data|
        csv << data
      end
    end
  end

end