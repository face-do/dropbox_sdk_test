# -*- coding: utf-8 -*-
require 'dropbox_sdk'

APP_KEY = 'INSERT-APP-KEY-HERE'
APP_SECRET = 'INSERT-APP-SECRET-HERE'
ACCESS_TYPE = :app_folder
session = DropboxSession.new(APP_KEY, APP_SECRET)

request_token = session.get_request_token

authorize_url = session.get_authorize_url
puts "AUTHORIZING", authorize_url
gets

access_token = session.get_access_token

p "request_token：", request_token
p "access_token：", access_token
