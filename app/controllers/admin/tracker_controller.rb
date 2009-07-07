module Admin
  class TrackerController < ApplicationController
    DEFAULT_RESULT = {"interval" => 30.minutes.to_i}

    def tracker
      torrent_id = params[:info_hash].bytes.map{|b| sprintf("%x", b)}.join("")

      Torrent.delete_old_clients
      torrent = Torrent.find_by_torrent_id(torrent_id)
      r = torrent.handle_client(params)

      render :text => DEFAULT_RESULT.merge(r).bencode
    rescue Exception => e
      logger.error(e)
      render :text => {"failure reason" => "Internal error"}.bencode
    end
  end
end
