class TrackController < ApplicationController
  #require 'action_controller/mime_type' 

  def show
    @album = Album.find_by_album_number(params[:album_id])
    @track = Track.find(:first, :conditions => {:album_id => @album, :track_number => params[:id]})
    @track.transaction do
      @track.download_count = @track.download_count + 1
      @track.save
    end
    respond_to do |format|
      format.mp3 {
        dname = ('Bumptious & ' + @track.name) + '.mp3'
        file_path = RAILS_ROOT + '/public/music/'+ @track.local_name + '.mp3'
        puts file_path
        send_file RAILS_ROOT + '/public/music/'+ @track.local_name + '.mp3', :filename => dname, :type=>"application/force-download"
      }
      format.m4a {
        dname = ('Bumptious & ' + @track.name) + '.m4a'
        send_file RAILS_ROOT + '/public/music/'+ @track.local_name + '.m4a', :filename => dname, :type=>"application/force-download"
      }
    end

  end

end
