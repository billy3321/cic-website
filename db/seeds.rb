# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Party.delete_all

filepath = Rails.root.join('db', 'g0v-lyparser', 'party.json')
parties = JSON.parse(File.read(filepath))
parties.each do |p|
  party = Party.new(p)
  party.id = p['id']
  party.save
end

Ad.delete_all

ads = [{
  :id => 8,
  :name => '第8屆',
  :vote_date => '2012-01-14',
  :term_start => '2012-02-01',
  :term_end => '2016-01-31'}]

ads.each do |a|
  ad = Ad.new(a)
  ad.id = a['id']
  a.save
end

ISO3166TW = {
  "CHA" => "彰化縣",
  "CYI" => "嘉義市",
  "CYQ" => "嘉義縣",
  "HSQ" => "新竹縣",
  "HSZ" => "新竹市",
  "HUA" => "花蓮縣",
  "ILA" => "宜蘭縣",
  "KEE" => "基隆市",
  "KHH" => "高雄市",
  "KHQ" => "高雄市",
  "MIA" => "苗栗縣",
  "NAN" => "南投縣",
  "PEN" => "澎湖縣",
  "PIF" => "屏東縣",
  "TAO" => "桃園縣",
  "TNN" => "台南市",
  "TNQ" => "台南市",
  "TPE" => "台北市",
  "TPQ" => "新北市",
  "TTT" => "台東縣",
  "TXG" => "台中市",
  "TXQ" => "台中市",
  "YUN" => "雲林縣",
  "JME" => "金門縣",
  "LJF" => "連江縣"
}

def constituency_parser(constituency)
  case (constituency[0])
  when 'proportional'
    return '全國不分區'
  when 'aborigine'
    return '山地原住民'
  when 'foreign'
    return '僑居國外國民'
  else
    if ISO3166TW[constituency[0]]
      if (constituency[1] == 0)
        result = ISO3166TW[constituency[0]]
      else
        result = ISO3166TW[constituency[0]] + '第' + constituency[1].to_s + '選區'
      end
    end
    return result
  end
end


Legislator.delete_all
Election.delete_all

#import mly-8.json
filepath = Rails.root.join('db', 'g0v-lyparser', 'mly-8.json')
legislators = JSON.parse(File.read(filepath))
legislators.each do |l|
  legislator = Legislator.new()
  legislator.id = l['id']
  legislator.name = l['name']
  legislator.in_office = l['in_office']
  legislator.image = l['id'].to_s + '.jpg'
  election = Election.new()
  election.legislator_id = l['id']
  election.ad_id = 8
  election.party_id = Party.where(abbreviation: l['party']).first.id
  election.constituency = constituency_parser(l['constituency'])
  legislator.save
  election.save
end

committees = [
  {:id => 1, :name => '內政委員會'},
  {:id => 5, :name => '經濟委員會'},
  {:id => 6, :name => '財政委員會'},
  {:id => 8, :name => '教育及文化委員會'},
  {:id => 9, :name => '交通委員會'},
  {:id => 12, :name => '社會福利及衛生環境委員會'},
  {:id => 13, :name => '程序委員會'},
  {:id => 17, :name => '外交及國防委員會'},
  {:id => 18, :name => '司法及法制委員會'},
  {:id => 19, :name => '院會'}]

Committee.delete_all
committees.each do |c|
  committee = Committee.new()
  committee.id = c.id
  committee.name = c.name
  committee.save
end



