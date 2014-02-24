# -*- encoding: utf-8 -*-
require 'mechanize'
require 'win32ole'

class WebClient
  # mechanizeの起動
  def initialize(debug = false)
    @debug = debug
    
    @client = Mechanize.new 
    @client.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @client.keep_alive = false
    @client.max_history=1
    @client.redirection_limit=3
    @client.user_agent_alias = 'Windows Mozilla'
  end
  
  def client
    @client
  end
  
  # return the page contents
  def get(url)
    @client.get(url)
  end
  
  def page
    @client.page
  end
  
  def page=(page)
    @client.page = page
  end
  
  def save(filepath = nil)
    filepath = filepath ? filepath : page.filename
    File.delete(filepath) if File.exists?(filepath)
    page.save(filepath)
    if @debug
      shell = WIN32OLE.new("WScript.Shell")
      shell.Run(Dir::pwd + filepath)
    end
  end
  
  def forms
    page.forms
  end
  
  def submit(form, button)
    @client.submit(form, button)
  end
  
  def clinks
    @client.page.links
  end
  
  def link_click(txt, err_check = true)
    link = clinks.find {|i|
      i.text == txt
    }
    raise "link is not found. text=#{txt}"  unless link if err_check
    return @client.click( link )
  end
end


