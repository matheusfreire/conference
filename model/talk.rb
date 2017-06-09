require 'json'

class Talk

  attr_reader :title, :duration
  attr_accessor :time_event, :inside

  def initialize(talk, duration = nil, time_event = nil)
    @title = set_name(talk)
    if duration.nil?
      @duration = set_duration(talk)
    else
      @duration = duration
    end
    @time_event = time_event
  end

  def self.valid?(talk)
    !talk.empty? && ( /[0-9]min/.match(talk) || talk.include?("lightning") )
  end

  def as_json(option={})
    {
        title: @title,
        duration: @duration

    }
  end

  private
    def set_name(talk)
      index = talk.index(/[0-9]+/) || talk.index('lightning')
      index.nil? ? talk: talk[0,index-1]
    end

    def set_duration(talk)
      talk.include?("lightning") ? 5: talk[-5..-4].to_i
    end

end