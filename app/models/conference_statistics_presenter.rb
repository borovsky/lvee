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
    attr_reader :statistics

    def initialize
      @statistics = Hash.new(0)
    end

    def update_statistics(reg)
      return if reg.cancelled?
      add_statistics :total_registrations
      add_statistics :total_men, reg.quantity
      if reg.approved?
        add_statistics :approved_registrations
        add_statistics :approved_men, reg.quantity

        add_statistics "transport_from_#{reg.transport_from}".to_sym
        add_statistics "transport_to_#{reg.transport_to}".to_sym

        (reg.days || "").downcase.split(",").each do |d|
          add_statistics "days_#{d}".to_sym
        end
      end
    end

    def add_statistics(key, count = 1)
      count ||= 0
      @statistics[key] +=  count
    end
  end
end
