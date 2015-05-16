# coding: utf-8
require 'mechanize'
require 'date'

def print_code_history_with_json_format (code, page)
  agent = Mechanize.new
  url = "http://info.finance.yahoo.co.jp/history/?code=#{code}&p=#{page}&sy=1990"
  page = agent.get(url)

  header = page.search(".//table[@class='boardFin yjSt marB6']/tr/th").map{|item| item.inner_html.chomp}
  values = []
  page.search(".//table[@class='boardFin yjSt marB6']/tr").each{|item|
    result = item.search("td").map{|x| x.inner_html.chomp}
    if not result.empty?
      date_tmp, *tmp = result
      nums = tmp.map{|item| item.gsub(/,/, "").to_i}
      date = Time.strptime(date_tmp, "%Y年%m月%d日").strftime("%Y-%m-%d")
      tmp = [date, *nums]
      result = {"code" => code, "id" => "#{code}_#{date}"}
      header.each_with_index{|item, idx|
        result[item] = tmp[idx]
      }
      puts result.to_json
    end
  }
end

["64314081", # SMTグローバルインデックスオープン
 "1306.T", # TOPIX上場インデックスオープン
 "998407.O", # 日経平均
 "6098.T", # (株)リクルートホールディングス
 "6758.T", # ソニー(株)
 "9432.T" # 日本電信電話(株)
].each{|code|
  (1..300).each{|page|
    print_code_history_with_json_format(code, page)
    sleep 1
  }
}
