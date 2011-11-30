class TrackController < ApplicationController
  CONSUMER_KEY = "4cnvu2bi0xk0jiw"
  CONSUMER_SECRET = "fvz6kv0etjj1625"

  def index
    if params[:oauth_token]
      dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
      dropbox_session.authorize(params)
      session[:dropbox_session] = dropbox_session.serialize # re-serialize the authenticated session

      redirect_to :action => 'list'
    else
      dropbox_session = Dropbox::Session.new(CONSUMER_KEY, CONSUMER_SECRET)
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.authorize_url(:oauth_callback => root_url)
    end

  end

  def list
    @files = {}
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    dropbox_session.list("music-classes/", {:mode => :dropbox}).each do |dir|
      @files[dir.path] = dropbox_session.list(dir.path, {:mode => :dropbox}).collect(&:path)
    end
  end
end
