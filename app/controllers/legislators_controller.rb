class LegislatorsController < ApplicationController
  before_action :set_legislator, except: [:index, :new, :no_record, :has_records, :search, :result]

  # GET /legislators
  def index
    if params[:format] == "json"
      if params[:query]
        @legislators = Legislator.where("name LIKE '%#{params[:query]}%'").offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.where("name LIKE '%#{params[:query]}%'").count
      else
        @legislators = Legislator.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.all.count
      end
    else
      @q = Legislator.search(params[:q])
      @legislators = @q.result(:distinct => true).all
    end
    @parties = Party.all

    set_meta_tags({
      title: '立委列表',
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: '立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍,國會委員',
      og: {
        type: 'website',
        title: '國會立委列表',
        description: '看看現任立委在國會殿堂的表現吧！'
      }
    })

    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislators: JSON.parse(@legislators.to_json(
          except: [:description, :now_party_id, :created_at, :updated_at],
          include: {party: {except: [:created_at, :updated_at]}
          })),
        count: @legislators_count},
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/no_record
  def no_record
    if params[:format] == "json"
      if params[:query]
        @legislators = Legislator.where("name LIKE '%#{params[:query]}%'").has_no_record.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.where("name LIKE '%#{params[:query]}%'").has_no_record.length
      else
        @legislators = Legislator.has_no_record.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.has_no_record.length
      end
    else
      @q = Legislator.has_no_record.search(params[:q])
      @legislators = @q.result(:distinct => true).all
    end
    @parties = Party.all

    set_meta_tags({
      title: '立委列表',
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: '立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍,國會委員',
      og: {
        type: 'website',
        title: '國會立委列表',
        description: '看看現任立委在國會殿堂的表現吧！'
      }
    })
    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislators: JSON.parse(@legislators.to_json(
          except: [:description, :now_party_id, :created_at, :updated_at],
          include: {party: {except: [:created_at, :updated_at]}
          })),
        count: @legislators_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/has_records
  def has_records
    if params[:format] == "json"
      if params[:query]
        @legislators = Legislator.where("name LIKE '%#{params[:query]}%'").has_records.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.where("name LIKE '%#{params[:query]}%'").has_records.length
      else
        @legislators = Legislator.has_records.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.has_records.length
      end
    else
      @q = Legislator.has_records.search(params[:q])
      @legislators = @q.result(:distinct => true).all
    end
    @parties = Party.all

    set_meta_tags({
      title: '立委列表',
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: '立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍,國會委員',
      og: {
        type: 'website',
        title: '國會立委列表',
        description: '看看現任立委在國會殿堂的表現吧！'
      }
    })
    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislators: JSON.parse(@legislators.to_json(
          except: [:associations_count, :description, :now_party_id, :created_at, :updated_at],
          include: {party: {except: [:created_at, :updated_at]}
          })),
        count: @legislators_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/1
  def show
    @videos = @legislator.videos.published.first(5)
    @main_video = @videos.shift
    @sub_videos = @videos
    @entries = @legislator.entries.published.first(5)
    @questions = @legislator.questions.published.first(5)

    set_meta_tags({
      title: "#{@legislator.name}調查報告",
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: "#{@legislator.name},#{@legislator.name}調查報告",
      og: {
        type: 'profile',
        description: "你知道#{@legislator.name}在國會的表現嗎？這裡是#{@legislator.name}的調查報告。",
        title: "#{@legislator.name}調查報告",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/legislators/160x214/#{@legislator.image}"
      }
    })

    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislator: JSON.parse(@legislator.to_json(
        except: [:description, :now_party_id, :created_at, :updated_at],
        include: {
          party: {except: [:created_at, :updated_at]},
          elections: {
            except: [:created_at, :updated_at],
            include: {ad: {except: [:created_at, :updated_at]}
            }
          },
          questions: {}, entries:{}, videos:{}
        }))},
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/1/entries
  def entries
    if params[:format] == "json"
      if params[:query]
        @entries = @legislator.entries.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @entries_count = @legislator.entries.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @entries = @legislator.entries.published.offset(params[:offset]).limit(params[:limit])
        @entries_count = @legislator.entries.published.count
      end
    else
      @entries = @legislator.entries.published.page(params[:page])
    end
    entries = @entries.clone.to_a
    @main_entry = entries.shift
    @sub_entries = entries

    set_meta_tags({
      title: "#{@legislator.name}新聞列表",
      description: @main_entry.try(:title),
      keywords: "#{@legislator.name},#{@legislator.name}新聞調查",
      og: {
        type: 'article',
        description: @main_entry.try(:title),
        title: "#{@legislator.name}新聞調查報告",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/legislators/160x214/#{@legislator.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          entries: JSON.parse(@entries.to_json({except: [:user_id, :user_ip, :published]})),
          count: @legislator.entries.published.count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/1/questions
  def questions
    if params[:format] == "json"
      if params[:query]
        @questions = @legislator.questions.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @questions_count = @legislator.questions.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @questions = @legislator.questions.published.offset(params[:offset]).limit(params[:limit])
        @questions_count = @legislator.questions.published.count
      end
    else
      @questions = @legislator.questions.published.page(params[:page])
    end
    questions = @questions.clone.to_a
    @main_question = questions.shift
    @sub_questions = questions

    set_meta_tags({
      title: "#{@legislator.name}質詢列表",
      description: @main_question.try(:title),
      keywords: "#{@legislator.name},#{@legislator.name}質詢調查",
      og: {
        type: 'article',
        description: @main_question.try(:title),
        title: "#{@legislator.name}質詢調查報告",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/legislators/160x214/#{@legislator.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          questions: JSON.parse(
            @questions.to_json({include: {
              ad_session: { except: [:created_at, :updated_at] },
              ad: { except: [:created_at, :updated_at] },
              committee: { except: [:created_at, :updated_at] }
            }, except: [:user_id, :user_ip, :published]})
          ),
          count: @questions_count
        },
        callback: params[:callback]
      }
    end

  end

  # GET /legislators/1/videos
  def videos
    if params[:format] == "json"
      if params[:query]
        @videos = @legislator.videos.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @videos_count = @legislator.videos.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @videos = @legislator.videos.published.offset(params[:offset]).limit(params[:limit])
        @videos_count = @legislator.videos.published.count
      end
    else
      @videos = @legislator.videos.published.page(params[:page])
    end
    videos = @videos.clone.to_a
    @main_video = videos.shift
    @sub_videos = videos

    set_meta_tags({
      title: "#{@legislator.name}影片列表",
      description: @main_video.try(:title),
      keywords: "#{@legislator.name},#{@legislator.name}影片調查",
      og: {
        type: 'video.tv_show',
        description: @main_video.try(:title),
        title: "#{@legislator.name}影片調查報告",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/legislators/160x214/#{@legislator.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          videos: JSON.parse(
            @videos.to_json({include: {
              ad_session: { except: [:created_at, :updated_at] },
              ad: { except: [:created_at, :updated_at] },
              committee: { except: [:created_at, :updated_at] }
            }, except: [:user_id, :user_ip, :published]})
          ),
          count: @videos_count
        },
        callback: params[:callback]
      }
    end
  end

  def votes
    page = params[:page]
    ad = params[:ad]
    ad = Ad.last.id if not ad or ad > Ad.last.id
    @votes, @pages, @status = parse_vote_guide_voter(@legislator.id, ad, page)
    errors.add(:base, '網址擷取失敗，請稍後重新嘗試。') unless @status
  end

  def bills
    page = params[:page]
    ad = params[:ad]
    ad = Ad.last.id if not ad or ad > Ad.last.id
    @bills, @pages, @status = parse_vote_guide_biller(@legislator.id, ad, page)
    errors.add(:base, '網址擷取失敗，請稍後重新嘗試。') unless @status
  end

  def candidate
    ad = params[:ad]
    ad = Ad.last.id if not ad or ad > Ad.last.id
    @candidate, @status = parse_vote_guide_biller(@legislator.id, ad)
    errors.add(:base, '網址擷取失敗，請稍後重新嘗試。') unless @status
  end

  def search
    @q = Election.search(params[:q])
  end

  def result
    @q = Election.search(params[:q])
    @ad_id_eq = params[:q] ? params[:q][:ad_id_eq] : nil
    @county_id_eq = params[:q] ? params[:q][:county_id_eq] : nil
    @party_id_eq = params[:q] ? params[:q][:party_id_eq] : nil
    if params[:q] and \
        params[:q][:ad_id_eq].blank? and \
        params[:q][:county_id_eq].blank? and \
        params[:q][:party_id_eq].blank? and \
        params[:q][:legislator_name_cont].blank?
      params[:commit] = nil
    end
    if params[:commit].blank?
      @title = ""
      @elections = []
    else
      @title = "立委"
      unless params[:q][:party_id_eq].blank?
        party = Party.find(params[:q][:party_id_eq])
        if party
          @title = party.name + @title
        end
      end
      unless params[:q][:county_id_eq].blank?
        county = County.find(params[:q][:county_id_eq])
        if county
          @title = county.name + @title
        end
      end
      unless params[:q][:ad_id_eq].blank?
        ad = Ad.find(params[:q][:ad_id_eq])
        if ad
          @title = ad.name + @title
        end
      end
      @elections = @q.result(:distinct => true).all
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_legislator
    @legislator = params[:id] ? Legislator.find(params[:id]) : Legislator.new(legislator_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def legislator_params
    params.require(:legislator).permit()
  end

  def parse_vote_guide_voter(legislator_id, ad, page = nil)
    if page
      url = "http://vote.ly.g0v.tw/legislator/voter/#{legislator_id}/#{ad}/?page=#{page}"
    else
      url = "http://vote.ly.g0v.tw/legislator/voter/#{legislator_id}/#{ad}/"
    end
    begin
      pages = []
      votes = []
      html = Nokogiri::HTML(get_cached_page(url))
      info_section = html.css('div.span9')[0]
      pagination_section = info_section.css('div.pagination')[0]
      pagination_section.css('li').each do | li |
        pages << li.text
      end
      pages = pages[1..-2]
      vote_section = info_section.css('tbody')[0]
      vote_section.css('tr').each do | tr |
        vote = {}
        tds = tr.css('td')
        vote[:ad] = tds[0].text.strip
        action = tds[1].text.strip
        if action == '贊成'
          vote[:action] = 'agree'
        elsif action == '棄權'
          vote[:action] = 'abstain'
        elsif action == '反對'
          vote[:action] = 'disagree'
        elsif action == '沒有投票'
          vote[:action] = 'notvote'
        else
          vote[:action] = 'unknown'
        end
        result = tds[2].text.strip
        if result == '通過'
          vote[:result] = 'passed'
        elsif result == '不通過'
          vote[:result] = 'notpass'
        else
          vote[:result] = 'unknown'
        end
        vote[:date] = tds[3].text.strip
        vote[:link] = "http://vote.ly.g0v.tw" + tds[4].css('a').attr('href').value
        vote[:content] = tds[4].text.strip.split("\n")[-1].strip
        votes << vote
      end
      return votes, pages, true
    rescue
      return [], [], false
    end
  end

  def parse_vote_guide_biller(legislator_id, ad, page = nil)
    if page
      url = "http://vote.ly.g0v.tw/legislator/biller/#{legislator_id}/#{ad}/?page=#{page}"
    else
      url = "http://vote.ly.g0v.tw/legislator/biller/#{legislator_id}/#{ad}/"
    end
    begin
      pages = []
      bills = []
      html = Nokogiri::HTML(get_cached_page(url))
      info_section = html.css('div.span9')[0]
      pagination_section = info_section.css('div.pagination')[0]
      pagination_section.css('li').each do | li |
        pages << li.text.strip
      end
      pages = pages[1..-2]
      bill_section = info_section.css('ul.media-list')[0]
      bill_section.css('li.media').each do | li |
        bill = {}
        bill[:reason] = li.css('div.media-heading').text.strip
        progress = []
        li.css('blockquote').text.split("\n").each do |text|
          text = text.strip
          progress << text unless text.blank?
        end
        if li.css('font.lead').any?
          bill[:warning] = li.css('font.lead').text
          progress = progress[1..-1]
        else
          bill[:warning] = nil
        end
        bill[:progress] = progress
        bill[:link] = li.css('a').attr('href').value
        bill[:id] = bill[:link].split('/')[-1]
        ly_g0v_url = "http://api.ly.g0v.tw/v0/collections/bills/#{bill[:id]}"
        ly_g0v_json = JSON.parse(get_cached_page(ly_g0v_url))
        bill[:title] = ly_g0v_json['summary']
        # bill[:reason] = ly_g0v_json['abstract']
        bills << bill
      end
      return bills, pages, true
    rescue
      return [], [], false
    end
  end

  def parse_vote_guide_candidate(legislator_id, ad)
    legislator_term_url = "http://vote.ly.g0v.tw/api/legislator_terms/?format=json&ad=#{ad}&legislator=#{legislator_id}"
    legislator_term_json = JSON.parse(get_cached_page(legislator_term_url))
    if legislator_term_json["results"].any?
      candidate_url = legislator_term_json["results"][0]["elected_candidate"][0]
      candidate_json = JSON.parse(get_cached_page(candidate_url))
      return candidate_json["politicalcontributions"], true
    else
      return {}, false
    end
  end
end
