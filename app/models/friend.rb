class Friend < ActiveRecord::Base

  def self.check_by_login login
    friends = Friend.all
    friend_hostnames = friends.inject({}) do |res, friend|
      res[friend.hostname] = friend.id

      res
    end

    private_key_file = File.join(Rails.root, "config/friendlist_private.pem")
    private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file)) rescue nil

    if private_key
      checks = friends.inject([]) do |res, friend|
        public_key = OpenSSL::PKey::RSA.new(friend.public_key) rescue nil

        if public_key
          message = public_key.public_encrypt(login).unpack("H*")[0]
          sign = private_key.sign(OpenSSL::Digest::SHA1.new, login).unpack("H*")[0]

          res.push({ :url => friend.hostname + 'friends/user_data.json',
                     :post_fields => { 'hostname' => friend.hostname,
                                       'message' => message,
                                       'sign' => sign } })
        end

        res
      end

      friend_statuses = {}
      require 'curb'
      #Curl::Multi.post(checks, {:follow_location => true}, {:pipeline => true}) do |easy|
      #  friend_statuses[friend_hostnames[easy.url.chomp "friends/user_data.json"]] = easy.response_code
      #end
      checks.each do |check|
        c = Curl::Easy.http_post(check[:url],
                                 Curl::PostField.content('message', check[:post_fields]['message']),
                                 Curl::PostField.content('sign', check[:post_fields]['sign']),
                                 Curl::PostField.content('hostname', check[:post_fields]['hostname']))

        friend_statuses[friend_hostnames[check[:url].chomp "friends/user_data.json"]] = JSON.parse c.body_str rescue nil
      end

      friend_statuses
    end
  end

  def self.for_list
    friends = Friend.all

    friend_hostnames = friends.inject({}) do |res, friend|
      res[friend.hostname] = friend.id

      res
    end

    friend_statuses = {}
    checks = friends.inject([]) do |res, friend|
      public_key = OpenSSL::PKey::RSA.new(friend.public_key) rescue nil

      unless public_key
        friend_statuses[friend.id] = :bad_public_key
      else
        message = public_key.public_encrypt('http://localhost:3030/').unpack("H*")[0]
        res.push({ :url => friend.hostname + 'friends/status.json', :post_fields => { 'message' => message, 'id' => friend.id } })
      end

      res
    end

    require 'curb'
    #Curl::Multi.post(checks, {:follow_location => true}, {:pipeline => true}) do |easy|
    #  friend_statuses[friend_hostnames[easy.url.chomp "friends/status.json"]] = easy.response_code
    #end
    checks.each do |check|
      c = Curl::Easy.http_post(check[:url],
                               Curl::PostField.content('message', check[:post_fields]['message']),
                               Curl::PostField.content('id', check[:post_fields]['id']))


      friend_statuses[friend_hostnames[check[:url].chomp "friends/status.json"]] = c.response_code
    end

    friends.collect do |friend|
      { :id => friend.id, :hostname => friend.hostname, :status => friend_statuses[friend.id] }
    end
  end

end
