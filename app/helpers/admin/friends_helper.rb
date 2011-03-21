module Admin
  module FriendsHelper

    def status code
      case code
      when :bad_public_key
        t ".status.bad_public_key"
      when 201
        t ".status.ok"
      when 412
        t ".status.precondition_failed"
      when 404
      when 0
      when nil
        t ".status.not_responding"
      else
        code
      end
    end

  end
end

