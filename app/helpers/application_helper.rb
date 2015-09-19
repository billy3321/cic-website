module ApplicationHelper
  def display_shorter(str, length, additional = "...")
    length = length * 2
    text = Nokogiri::HTML(str).text
    if text.display_width >= length
      additional_text = Nokogiri::HTML(additional).text
      new_length = length - additional_text.display_width
      short_string = text[0..new_length]
      while short_string.display_width > new_length
        short_string = short_string[0..-2]
      end
      short_string + additional
    else
      text
    end
  end

  def get_percentage(numerator, denominator, with_percent_mark = true)
    if with_percent_mark
      mark = "%"
    else
      mark = ""
    end
    unless numerator.blank?
      return ((numerator.to_f / denominator.to_f) * 100.0).round(2).to_s + mark
    else
      return "0" + mark
    end
  end

  def to_ten_thousands(number)
    (number.to_f / 10000).round(2).to_s + "萬"
  end

  def default_meta_tags
    {
      separator: "—",
      site: '國會調查兵團 CIC',
      reverse: true,
      description: ' ',
      og: {
        title: '國會調查兵團 CIC',
        description: ' ',
        type: 'website',
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/FB-img-default.gif",
        site_name: '國會調查兵團' }
    }
  end
end
