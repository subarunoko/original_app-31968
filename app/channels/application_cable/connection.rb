# module ApplicationCable
#   class Connection < ActionCable::Connection::Base
#   end
# end

module ApplicationCable
  class Connection < ActionCable::Connection::Base
  #channelでcurrent_userが使えるようにする
  identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
    def find_verified_user
      verified_user = User.find_by(id: env['warden'].user.id)
      return reject_unauthorized_connection unless verified_user
      verified_user
    end

    def session
      cookies.encrypted[Rails.application.config.session_options[:key]]
    end
  end
end


# module ApplicationCable
#   class Connection < ActionCable::Connection::Base
#     identified_by :current_user

#     def connect
#       reject_unauthorized_connection unless find_verified_user
#     end

#     private

#     def find_verified_user
#       self.current_user = env['warden'].user
#     end
#   end
# end
