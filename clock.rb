# -*- coding: utf-8 -*-
require 'clockwork'
require 'twitter'
require 'dropbox_sdk'
include Clockwork
@time = Time.now

Twitter.configure do |config|
  config.consumer_key = 'XXXXXXXXXXXXXXXX'
  config.consumer_secret = 'XXXXXXXXXXXXXXXX'
  config.oauth_token = 'XXXXXXXXXXXXXXXX'
  config.oauth_token_secret = 'XXXXXXXXXXXXXXXX'
end

APP_KEY = 'INSERT-APP-KEY-HERE'
APP_SECRET = 'INSERT-APP-SECRET-HERE'
ACCESS_TYPE = :app_folder
session = DropboxSession.new(APP_KEY, APP_SECRET)
session.set_request_token('REQUEST_TOKEN_KEY', 'REQUEST_TOKEN_SECRET')
session.set_access_token('ACCESS_TOKEN_KEY', 'ACCESS_TOKEN_SECRET')
client = DropboxClient.new(session, ACCESS_TYPE)

handler do |job|
  filedata = nil
  file_metadata = client.metadata('/') 
  filedata = file_metadata["contents"].map { |x| x if Time.parse( x["modified"]) > @time }
  filedata.each do |f|
   unless f == nil
    file = client.get_file(f["path"])
    filename = Time.now.to_i.to_s
    File.open("/tmp/" + filename, "w") {|f| f.write file}
    tmp = File.open("/tmp/" + filename, "rb")
    p tmp
    Twitter.update_with_media(@time.strftime("%F %H:%M"), tmp)
   end
  end
  @time = Time.now
end

every(1.minutes, 'check')

