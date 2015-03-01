# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Party.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Party.table_name)

filepath = Rails.root.join('db', 'g0v-lyparser', 'party.json')
parties = JSON.parse(File.read(filepath))
parties.each do |p|
  party = Party.new(p)
  party.id = p['id']
  party.save
end

Ad.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Ad.table_name)

ads = [{
  :id => 8,
  :name => '第8屆',
  :vote_date => '2012-01-14',
  :term_start => '2012-02-01',
  :term_end => '2016-01-31'}]

ads.each do |a|
  ad = Ad.new(a)
  ad.id = a[:id]
  ad.save
end

AdSession.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(AdSession.table_name)

ad_sessions = [
  {:id => 1, :ad_id => ads.first[:id], :name => '第1會期', :date_start => '2012-02-24', :date_end => '2012-06-15'},
  {:id => 2, :ad_id => ads.first[:id], :name => '第1會期第1次臨時會', :date_start => '2012-07-24', :date_end => '2012-07-26'},
  {:id => 3, :ad_id => ads.first[:id], :name => '第2會期', :date_start => '2012-09-18', :date_end => '2013-01-15'},
  {:id => 4, :ad_id => ads.first[:id], :name => '第3會期', :date_start => '2013-02-26', :date_end => '2013-05-31'},
  {:id => 5, :ad_id => ads.first[:id], :name => '第3會期第1次臨時會', :date_start => '2013-06-13', :date_end => '2013-06-27'},
  {:id => 6, :ad_id => ads.first[:id], :name => '第3會期第2次臨時會', :date_start => '2013-07-30', :date_end => '2013-08-06'},
  {:id => 7, :ad_id => ads.first[:id], :name => '第4會期', :date_start => '2013-09-17', :date_end => '2014-01-14'},
  {:id => 8, :ad_id => ads.first[:id], :name => '第4會期第1次臨時會', :date_start => '2014-01-27', :date_end => '2014-01-28'},
  {:id => 9, :ad_id => ads.first[:id], :name => '第5會期', :date_start => '2014-02-21', :date_end => '2014-05-30'},
  {:id => 10, :ad_id => ads.first[:id], :name => '第5會期第1次臨時會', :date_start => '2014-06-13', :date_end => '2014-07-04'},
  {:id => 11, :ad_id => ads.first[:id], :name => '第5會期第2次臨時會', :date_start => '2014-07-28', :date_end => '2014-08-08'},
  {:id => 12, :ad_id => ads.first[:id], :name => '第6會期', :date_start => '2014-09-12', :date_end => '2015-01-23'},
  {:id => 13, :ad_id => ads.first[:id], :name => '第7會期', :date_start => '2015-02-24', :date_end => nil}
]

ad_sessions.each do |a|
  ad_session = AdSession.new(a)
  ad_session.save
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
    if constituency[1] == 'lowland'
      return '平地原住民'
    elsif constituency[1] == 'highland'
      return '山地原住民'
    end
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

County.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(County.table_name)

counties = [{id: 1, name: "全國不分區"},
{id: 2, name: "基隆市"},
{id: 3, name: "臺北市"},
{id: 4, name: "新北市"},
{id: 5, name: "桃園市"},
{id: 6, name: "新竹市"},
{id: 7, name: "新竹縣"},
{id: 8, name: "苗栗縣"},
{id: 9, name: "臺中市"},
{id: 10, name: "彰化縣"},
{id: 11, name: "南投縣"},
{id: 12, name: "雲林縣"},
{id: 13, name: "嘉義市"},
{id: 14, name: "嘉義縣"},
{id: 15, name: "臺南市"},
{id: 16, name: "高雄市"},
{id: 17, name: "屏東縣"},
{id: 18, name: "臺東縣"},
{id: 19, name: "花蓮縣"},
{id: 20, name: "宜蘭縣"},
{id: 21, name: "澎湖縣"},
{id: 22, name: "金門縣"},
{id: 23, name: "連江縣"},
{id: 24, name: "平地原住民"},
{id: 25, name: "山地原住民"},
{id: 26, name: "僑居國外國民"}]

counties.each do |c|
  county = County.new()
  county.id = c[:id]
  county.name = c[:name]
  county.save
end
ActiveRecord::Base.connection.reset_pk_sequence!(County.table_name)

Legislator.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Legislator.table_name)
Election.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Election.table_name)

District.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(District.table_name)
# Ugly hack
ActiveRecord::Base.connection.execute("Delete from districts_elections;");

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
  election.ad_id = ads.first[:id]
  election.party_id = Party.where(abbreviation: l['party']).first.id
  constituency = constituency_parser(l['constituency'])
  election.constituency = constituency
  legislator.save
  election.save
  if l['county']
    county = County.where(name: l['county'][0]).first
    unless county
      county = County.new(name: l['county'][0])
      county.save
    end
    election.county = county
    l['district'].each do |d|
      district = District.where("name = ? AND county_id = ?", d, county.id).first
      unless district
        district = District.new(name: d)
        district.county = county
        district.save
      end
      election.districts << district
    end
  else
    county = County.where(name: constituency).first
    unless county
      county = County.new(name: constituency)
      county.save
    end
    election.county = county
  end
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
  {:id => 19, :name => '院會'},
  {:id => 28, :name => '紀律委員會'},
  {:id => 29, :name => '修憲委員會'},
  {:id => 30, :name => '經費稽核委員會'},
  {:id => 41, :name => '全院委員會'}
]

Committee.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Committee.table_name)

committees.each do |c|
  committee = Committee.new()
  committee.id = c[:id]
  committee.name = c[:name]
  committee.save
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end



