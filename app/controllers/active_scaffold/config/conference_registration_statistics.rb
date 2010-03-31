module ActiveScaffold::Config
  class ConferenceRegistrationStatistics < Form
    self.crud_type = :read
    def initialize(core_config)
      @core = core_config
      @link = self.class.link.clone
    end

    cattr_accessor :link

    @@link = ActiveScaffold::DataStructures::ActionLink.new(:show_statistics, :label => :statistics, :type => :collection)

    attr_accessor :link
  end
end
