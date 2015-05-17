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
 "9432.T", # 日本電信電話(株)
 "6701.t", # ＮＥＣ
 "7203.t", # トヨタ自動車(株)
 "7267.t", # ホンダ
 "8267.t", # イオン(株)
 "3382.t", # (株)セブン＆アイ・ホールディングス
 "9433.t", # ＫＤＤＩ(株)
 "9437.t", # (株)ＮＴＴドコモ
 "6902.t", # (株)デンソー
 "9984.t", # ソフトバンク(株)
 "4324.t", # (株)電通
 "4689.t", # ヤフー(株)
 "6981.t", # (株)村田製作所
 "2121.t", # (株)ミクシィ
].each{|code|
  (1..3).each{|page|
    print_code_history_with_json_format(code, page)
    sleep 1
  }
}
