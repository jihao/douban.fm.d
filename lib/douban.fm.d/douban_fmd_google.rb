# encoding: UTF-8
module DoubanFMD
  require 'mechanize'
  require 'douban.fm'

  class DoubanFMDGoogle

    def initialize(logger = DoubanFM::DummyLogger.new, distr = './mp3')
      @logger = logger
      @distr = distr
    end

    def download(title, artist)
      agent = Mechanize.new

      proxy = ENV['HTTP_PROXY'] || ENV['HTTPS_PROXY']
      unless proxy.nil?
        m = proxy.match(/(http(s)?:\/\/)?(?<proxy_addr>.*):(?<proxy_port>[0-9]*)/)
        agent.set_proxy(m['proxy_addr'], m['proxy_port'].to_i)
      end

      keyword = "#{title}-#{artist}".encode('utf-8')  #ticky one
      @logger.log "INPUT: #{keyword}"
      @logger.log "SEARCH: http://www.top100.cn/search/?act=allsong&keyword=#{keyword}"
      page = agent.get("http://www.top100.cn/search/?act=allsong&keyword=#{keyword}")

      expression = %r{javascript:page.common.openDownload\(\'m(.*)\'\).*}
      # use the first link as best match result
      links = page.links_with(:dom_class => 'down', :href => expression)
      productid = links.first.href.match(expression)[1]

      @logger.log "FOUND: http://www.top100.cn/download/download.php?Productid=#{productid}"
      page2 = agent.get("http://www.top100.cn/download/download.php?Productid=#{productid}")
      link2 = page2.link_with(:href => %r{/download/dl.php\?n=(.*).mp3(.*)})

      @logger.log "DOWNLOAD: http://www.top100.cn#{link2.href}"
      agent.pluggable_parser.default = Mechanize::Download
      mp3 = agent.get("http://www.top100.cn#{link2.href}").save("#{@distr}/#{keyword}.mp3")
      @logger.log "Save it to #{@distr}/#{keyword}.mp3"

      "#{@distr}/#{keyword}.mp3"
    end
  end

end