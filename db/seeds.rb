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

committees = [
  {:id => 1, :name => '內政委員會', :kind => 'sc'},
  {:id => 5, :name => '經濟委員會', :kind => 'sc'},
  {:id => 6, :name => '財政委員會', :kind => 'sc'},
  {:id => 8, :name => '教育及文化委員會', :kind => 'sc'},
  {:id => 9, :name => '交通委員會', :kind => 'sc'},
  {:id => 12, :name => '社會福利及衛生環境委員會', :kind => 'sc'},
  {:id => 13, :name => '程序委員會', :kind => 'ac'},
  {:id => 17, :name => '外交及國防委員會', :kind => 'sc'},
  {:id => 18, :name => '司法及法制委員會', :kind => 'sc'},
  {:id => 19, :name => '院會', :kind => 'yc'},
  {:id => 28, :name => '紀律委員會', :kind => 'ac'},
  {:id => 15, :name => '修憲委員會', :kind => 'ac'},
  {:id => 30, :name => '經費稽核委員會', :kind => 'ac'},
  {:id => 41, :name => '全院委員會', :kind => 'ac'}
]

Committee.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Committee.table_name)

committees.each do |c|
  committee = Committee.new()
  committee.id = c[:id]
  committee.name = c[:name]
  committee.kind = c[:kind]
  committee.save
end

Ad.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Ad.table_name)

ads = [
    {
      :id => 8,
      :name => '第8屆',
      :vote_date => '2012-01-14',
      :term_start => '2012-02-01',
      :term_end => '2016-01-31'
    }, {
      :id => 9,
      :name => '第9屆',
      :vote_date => '2016-01-16',
      :term_start => '2016-02-01',
      :term_end => '2020-01-31'
    }
  ]

ads.each do |a|
  ad = Ad.new(a)
  ad.id = a[:id]
  ad.save
end

AdSession.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(AdSession.table_name)

ad_sessions = [
  {:id => 1, :ad_id => 8, :name => '第1會期', :date_start => '2012-02-24', :date_end => '2012-06-15', :regular => true, :session => 1},
  {:id => 2, :ad_id => 8, :name => '第1會期第1次臨時會', :date_start => '2012-07-24', :date_end => '2012-07-26', :regular => false, :session => 1},
  {:id => 3, :ad_id => 8, :name => '第2會期', :date_start => '2012-09-18', :date_end => '2013-01-15', :regular => true, :session => 2},
  {:id => 4, :ad_id => 8, :name => '第3會期', :date_start => '2013-02-26', :date_end => '2013-05-31', :regular => true, :session => 3},
  {:id => 5, :ad_id => 8, :name => '第3會期第1次臨時會', :date_start => '2013-06-13', :date_end => '2013-06-27', :regular => false, :session => 3},
  {:id => 6, :ad_id => 8, :name => '第3會期第2次臨時會', :date_start => '2013-07-30', :date_end => '2013-08-06', :regular => false, :session => 3},
  {:id => 7, :ad_id => 8, :name => '第4會期', :date_start => '2013-09-17', :date_end => '2014-01-14', :regular => true, :session => 4},
  {:id => 8, :ad_id => 8, :name => '第4會期第1次臨時會', :date_start => '2014-01-27', :date_end => '2014-01-28', :regular => false, :session => 4},
  {:id => 9, :ad_id => 8, :name => '第5會期', :date_start => '2014-02-21', :date_end => '2014-05-30', :regular => true, :session => 5},
  {:id => 10, :ad_id => 8, :name => '第5會期第1次臨時會', :date_start => '2014-06-13', :date_end => '2014-07-04', :regular => false, :session => 5},
  {:id => 11, :ad_id => 8, :name => '第5會期第2次臨時會', :date_start => '2014-07-28', :date_end => '2014-08-08', :regular => false, :session => 5},
  {:id => 12, :ad_id => 8, :name => '第6會期', :date_start => '2014-09-12', :date_end => '2015-01-23', :regular => true, :session => 6},
  {:id => 13, :ad_id => 8, :name => '第7會期', :date_start => '2015-02-24', :date_end => '2015-06-16', :regular => true, :session => 7},
  {:id => 14, :ad_id => 8, :name => '第8會期', :date_start => '2015-09-15', :date_end => '2015-12-18', :regular => true, :session => 8},
  {:id => 15, :ad_id => 9, :name => '第1會期', :date_start => '2016-02-19', :date_end => nil, :regular => true, :session => 1}
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
  "KHQ" => "高雄縣",
  "MIA" => "苗栗縣",
  "NAN" => "南投縣",
  "PEN" => "澎湖縣",
  "PIF" => "屏東縣",
  "TAO" => "桃園市",
  "TNN" => "臺南市",
  "TNQ" => "臺南縣",
  "TPE" => "臺北市",
  "NWT" => "新北市",
  "TPQ" => "新北市",
  "TTT" => "臺東縣",
  "TXG" => "臺中市",
  "TXQ" => "臺中縣",
  "YUN" => "雲林縣",
  "KIN" => "金門縣",
  "JME" => "金門縣",
  "LIE" => "連江縣",
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

def county_parser(constituency)
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
      return ISO3166TW[constituency[0]]
    else
      return '不明'
    end
  end
end

def get_page(url)
  response = HTTParty.get(url)
  if response.code == 200
    return response.body
  else
    return false
  end
end

def get_vote_guide_legislator_term_data(legislator_id, ad)
  legislator_term_url = "http://vote.ly.g0v.tw/api/legislator_terms/?format=json&ad=#{ad}&legislator=#{legislator_id}"
  legislator_term_json = JSON.parse(get_page(legislator_term_url))
  if legislator_term_json["results"].any?
    return legislator_term_json["results"][0]
  else
    return nil
  end
end

def get_vote_guide_candidate_data(candidate_url)
  candidate_json = JSON.parse(get_page(candidate_url))
  unless candidate_json.blank?
    return candidate_json
  else
    return nil
  end
end

County.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(County.table_name)

counties = [{id: 1, name: "全國不分區"},
{id: 2, name: "基隆市"},
{id: 3, name: "臺北市"},
{id: 4, name: "新北市"},
{id: 5, name: "桃園市"},
{id: 6, name: "桃園縣"},
{id: 7, name: "新竹市"},
{id: 8, name: "新竹縣"},
{id: 9, name: "苗栗縣"},
{id: 10, name: "臺中市"},
{id: 11, name: "彰化縣"},
{id: 12, name: "南投縣"},
{id: 13, name: "雲林縣"},
{id: 14, name: "嘉義市"},
{id: 15, name: "嘉義縣"},
{id: 16, name: "臺南市"},
{id: 17, name: "高雄市"},
{id: 18, name: "屏東縣"},
{id: 19, name: "臺東縣"},
{id: 20, name: "花蓮縣"},
{id: 21, name: "宜蘭縣"},
{id: 22, name: "澎湖縣"},
{id: 23, name: "金門縣"},
{id: 24, name: "連江縣"},
{id: 25, name: "平地原住民"},
{id: 26, name: "山地原住民"},
{id: 27, name: "僑居國外國民"}]

counties.each do |c|
  county = County.new()
  county.id = c[:id]
  county.name = c[:name]
  county.save
end
ActiveRecord::Base.connection.reset_pk_sequence!(County.table_name)

Legislator.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Legislator.table_name)
LegislatorCommittee.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(LegislatorCommittee.table_name)
Election.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Election.table_name)
District.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(District.table_name)
# Ugly hack
ActiveRecord::Base.connection.execute("Delete from districts_elections;");

ads.each do |ad|
  #import mly-{ad}.json
  legislators_filepath = Rails.root.join('db', 'g0v-lyparser', "mly-#{ad[:id]}.json")
  legislators_links_filepath = Rails.root.join('db', 'data', 'legislator-links.json')
  legislators = JSON.parse(File.read(legislators_filepath))
  legislator_links = JSON.parse(File.read(legislators_links_filepath))
  legislators.each do |l|
    vote_guide_data = get_vote_guide_legislator_term_data(l['uid'], ad[:id])
    unless vote_guide_data.blank?
      l['county'] = vote_guide_data['county'] unless vote_guide_data['county'].blank?
      if ad[:id] == 8 and l['county'] == "桃園市"
        l['county'] == "桃園縣"
      elsif ad[:id] > 8 and l['county'] == "桃園縣"
        l['county'] == "桃園市"
      end
      if vote_guide_data['district'].blank?
        if vote_guide_data['elected_candidate'].present? and vote_guide_data['elected_candidate'].length > 0
          if vote_guide_data['elected_candidate'].kind_of?(Array)
            candidate_url = vote_guide_data['elected_candidate'].first
          else
            candidate_url = vote_guide_data['elected_candidate']
          end
          candidate_data = get_vote_guide_candidate_data(candidate_url)
          l['district'] = candidate_data['district'].split('，')
        end
      else
        l['district'] = vote_guide_data['district'].split('，')
      end
    end
    if Legislator.exists? l['uid']
      legislator = Legislator.find(l['uid'])
    else
      legislator = Legislator.new()
      legislator.id = l['uid']
      # if l['id'] == 1747
        # 徐欣瑩現在屬於民國黨
        # legislator.now_party_id = 7
      # end
      legislator.name = l['name']
      legislator.in_office = l['in_office']
      legislator.image = l['uid'].to_s + '.jpg'
      legislator_links.each do |links|
        if links[0].to_i == l['uid']
          legislator.fb_link = links[2] unless links[2].blank?
          legislator.wiki_link = links[3] unless links[3].blank?
          legislator.musou_link = links[4] unless links[4].blank?
          legislator.ccw_link = links[5] unless links[5].blank?
          legislator.ivod_link = links[6] unless links[6].blank?
        end
      end
    end
    election = Election.new()
    election.legislator_id = l['uid']
    election.ad_id = ad[:id]
    election.party_id = Party.where(abbreviation: l['party']).first.id
    constituency = constituency_parser(l['constituency'])
    election.constituency = constituency
    legislator.save
    election.save
    l['committees'].each do |c|
      legislator_committee = LegislatorCommittee.new
      legislator_committee.ad_session = AdSession.where(ad_id: c['ad'], session: c['session'], regular: true).first
      legislator_committee.convener = c["chair"]
      legislator_committee.legislator = legislator
      legislator_committee.committee = Committee.where(name: c["name"]).first
      legislator_committee.save
    end
    if l['county']
      county = County.where(name: l['county']).first
      unless county
        county = County.new(name: l['county'])
        county.save
      end
      election.county = county
      unless l['district'].blank?
        l['district'].each do |d|
          district = District.where("name = ? AND county_id = ?", d, county.id).first
          unless district
            district = District.new(name: d)
            district.county = county
            district.save
          end
          election.districts << district
        end
      end
    else
      county = County.where(name: county_parser(l['constituency'])).first
      unless county
        county = County.new(name: county_parser(l['constituency']))
        county.save
      end
      election.county = county
    end
    election.save
  end
end

# CCW Data import
CcwCommitteeDatum.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(CcwCommitteeDatum.table_name)
CcwLegislatorDatum.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(CcwLegislatorDatum.table_name)
CcwCitizenScore.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(CcwCitizenScore.table_name)

Ad.all.each do |ad|
  if [8].include? ad.id
    ad.ad_sessions.each do |ad_session|
      if ["第4會期", "第5會期", "第6會期", "第7會期"].include? ad_session.name
        ccw_committee_data_filepath = Rails.root.join('db', 'data', 'ccw', "#{ad.id}-#{ad_session.session}_committee_data.json")
        ccw_committee_data = JSON.parse(File.read(ccw_committee_data_filepath))
        ccw_committee_data.each do |c|
          ccw_committee_datum = CcwCommitteeDatum.new
          ccw_committee_datum.ad_session = ad_session
          ccw_committee_datum.committee = Committee.find(c[1])
          ccw_committee_datum.should_attendance = c[2]
          ccw_committee_datum.actually_average_attendance = c[3]
          ccw_committee_datum.avaliable_interpellation_count = c[4] unless c[4].blank?
          ccw_committee_datum.actually_average_interpellation_count = c[5] unless c[5].blank?
          ccw_committee_datum.save
        end
        ccw_legislator_data_filepath = Rails.root.join('db', 'data', 'ccw', "#{ad.id}-#{ad_session.session}_legislator_data.json")
        ccw_legislator_data = JSON.parse(File.read(ccw_legislator_data_filepath))
        ccw_legislator_data.each do |c|
          ccw_legislator_datum = CcwLegislatorDatum.new
          legislator_committee = LegislatorCommittee.where(legislator_id: c[0].to_i, ad_session_id: ad_session.id, committee_id: c[4]).first
          ccw_legislator_datum.legislator_committee = legislator_committee
          ccw_legislator_datum.yc_attendance = c[5]
          ccw_legislator_datum.sc_attendance = c[6]
          ccw_legislator_datum.sc_interpellation_count = c[7]
          ccw_legislator_datum.first_proposal_count = c[8]
          ccw_legislator_datum.not_first_proposal_count = c[9]
          ccw_legislator_datum.budgetary_count = c[10]
          ccw_legislator_datum.auditing_count = c[11]
          ccw_legislator_datum.citizen_score = c[12]
          ccw_legislator_datum.new_sunshine_bills = c[13]
          ccw_legislator_datum.modify_sunshine_bills = c[14]
          ccw_legislator_datum.budgetary_deletion_passed = c[15]
          ccw_legislator_datum.budgetary_deletion_impact = c[16]
          ccw_legislator_datum.budgetary_deletion_special = c[17]
          ccw_legislator_datum.special = c[18]
          ccw_legislator_datum.conflict_expose = c[19]
          ccw_legislator_datum.allow_visitor = c[20]
          ccw_legislator_datum.human_rights_infringing_bill = c[21]
          ccw_legislator_datum.human_rights_infringing_budgetary = c[22]
          ccw_legislator_datum.judicial_case = c[23]
          ccw_legislator_datum.disorder = c[24]
          ccw_legislator_datum.save
        end
        ccw_citizen_scores_filepath = Rails.root.join('db', 'data', 'ccw', "#{ad.id}-#{ad_session.session}_citizen_scores.json")
        ccw_citizen_scores = JSON.parse(File.read(ccw_citizen_scores_filepath))
        ccw_citizen_score = CcwCitizenScore.new
        ccw_citizen_score.ad_session = ad_session
        ccw_citizen_score.total = ccw_citizen_scores["total"]
        ccw_citizen_score.average = ccw_citizen_scores["average"]
        ccw_citizen_score.ccw_link = ccw_citizen_scores["ccw_link"]
        ccw_citizen_score.save
      end
    end
  end
end

# Event data import

Incantation.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!(Incantation.table_name)

incantations = [
  {
    id: 1,
    title: "用功認真閃光咒",
    word: "天眼勅我紙，書符驅鬼邪，電灼筆光納，認真天下傳。急急如律令。",
    positive: true
  }, {
    id: 2,
    title: "問政犀利強心咒",
    word: "神將無極，律令九章，霹靂問政，諸鬼伏藏，神兵急急如律令。",
    positive: true
  }, {
    id: 3,
    title: "弱勢發聲響聲咒",
    word: "天眼無極，公民發聲，孤苦弱勢，神墨急磨，立委疾行，霹靂雷霆。風火雷電如律令。",
    positive: true
  }, {
    id: 4,
    title: "囂張跋扈收斂咒",
    word: "天眼尊尊，日月無極，接我號令，天將壓頂，囂張氣焰，無所遁形，符至則行，雷電急急如律令。",
    positive: false
  }, {
    id: 5,
    title: "曠職怠工上工咒",
    word: "天皇皇，地皇皇，立院有個懶委郎，持符君子念一遍，懶委上工不得閒！",
    positive: false
  }, {
    id: 6,
    title: "公私不分明辨咒",
    word: "公器公用，私心避嫌，公私分明，廉潔自守，神兵火急如律令。",
    positive: false
  }, {
    id: 7,
    title: "護航作戲終結咒",
    word: "無極天眼神將，電灼筆光納，一則削貪官，再則縛爛委，一切都終亡，天道必重生。風火急急如律令。",
    positive: false
  }, {
    id: 8,
    title: "胡言亂語矯正咒",
    word: "太上天眼，無極所至，驅邪縛魅，淨身醒腦；智慧明凈，心神安寧，言行合一，言無不實。急急如律令。",
    positive: false
  }, {
    id: 9,
    title: "昨是今非打臉咒",
    word: "公民開眼，天眼無極；時光朔源，歷史言行；青龍白虎，真相現形；朱雀玄武，還彼初心。急急如律令。",
    positive: false
  }
]

incantations.each do |i|
  incantation = Incantation.new(i)
  incantation.id = i[:id]
  incantation.save
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end



