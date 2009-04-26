class ConferenceStatisticsPresenter
  def initialize(users, conferences)
    @users = users
    @conferences = conferences
  end

  def list
    @statistics ||= do_generate_statistics
  end

  private
  def do_generate_statistics
    statistics = {}
    @conferences.each{|c|
      statistics[c.name] = statistics_for(c)
    }
    statistics
  end

  def statistics_for(conference)
    conference_statistics = ConferenceStatistics.new
    @users.each do |u|
      reg = u.conference_registrations.detect {|cr| cr.conference == conference}
      conference_statistics.update_statistics(reg) if reg
    end
    conference_statistics
  end

  class ConferenceStatistics
    STATISTIC_ITEMS =  STATISTICS_TYPES.keys
    attr_accessor *STATISTIC_ITEMS

    def initialize
      STATISTIC_ITEMS.each {|i| send("#{i}=", 0)}
    end

    def update_statistics(reg)
      self.total_registrations += 1
      self.total_mans += reg.quantity || 0
      if reg.status_name == APPROVED_STATUS
        self.approved_mans += reg.quantity 
        self.approved_registrations += 1
      end
    end
  end
end
