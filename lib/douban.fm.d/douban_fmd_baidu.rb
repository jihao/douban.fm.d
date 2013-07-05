# encoding: UTF-8
module DoubanFMD
  require 'mechanize'
  require 'douban.fm'

  class DoubanFMDBaidu

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
      @logger.log "SEARCH: http://music.baidu.com/search?key=#{keyword}"
      page = agent.get("http://music.baidu.com/search?key=#{keyword}")

      expression = %r{^\/song\/(.*)}
      # use the first link as best match result
      links = page.links_with(:href=>/^\/song\/.*/).find_all{|link| link.text.eql?("#{title}".encode('utf-8'))}
      @logger.log "SEARCH FOUND: #{links.size}"
      song_id = links.first.href.match(expression)[1]

      @logger.log "SELECT: http://music.baidu.com/song/64364551/download?__o=%2Fsong%2F#{song_id}"
      page2 = agent.get("http://music.baidu.com/song/64364551/download?__o=%2Fsong%2F#{song_id}")
      link2 = page2.link_with(:dom_id=>"128")

      @logger.log "DOWNLOAD: http://music.baidu.com#{link2.href}"
      agent.pluggable_parser.default = Mechanize::Download
      mp3 = agent.get("http://music.baidu.com#{link2.href}").save("#{@distr}/#{keyword}.mp3")
      @logger.log "Save it to #{@distr}/#{keyword}.mp3"

      "#{@distr}/#{keyword}.mp3"
    end
  end

end