require 'date'

class Track

  attr_accessor :name, :actual_time, :talks, :lunch_time, :end_time, :afternoon_begin, :minutes_remaining


  def initialize(name)
    @name = name
    @actual_time = Time.new(Time.now.year, Time.now.month, Time.now.day, 9, 0, 0, nil)
    @talks = Array.new
    @lunch_time = Time.new(Time.now.year, Time.now.month, Time.now.day, 12, 0, 0, nil)
    @afternoon_begin = Time.new(Time.now.year, Time.now.month, Time.now.day, 13, 0, 0, nil)
    @end_time = Time.new(Time.now.year, Time.now.month, Time.now.day, 17, 0, 0, nil)
    @minutes_remaining = 180
  end

  def add_talk(talk)
    if talks.empty?
      add_new_talk(talk)
    else
      new_time = self.actual_time + talk.duration * 60
      new_datetime = set_new_date_after_add(new_time,new_time.hour, new_time.strftime("%M"))
      if new_datetime <= lunch_time
        add_new_talk(talk)
        if new_datetime == lunch_time
          create_lunch
        end
      elsif new_datetime > lunch_time && new_datetime < afternoon_begin
        create_lunch
        add_new_talk(talk)
      elsif new_datetime < end_time
        add_new_talk(talk)
      else new_datetime >= end_time
        add_new_talk(talk)
        self.actual_time = end_time
        talks << Talk.new("Networking Event", 0, self.actual_time)
      end
    end
  end

  def create_lunch
    self.actual_time = lunch_time
    talks << Talk.new("Lunch", 60, self.actual_time)
    self.actual_time = afternoon_begin
    self.minutes_remaining = 240
  end

  def full?
    talks.last.title == "Networking Event" if talks.any?
  end

  def info
    puts "===== #{name} ===="
    talks.each do |t|
      puts t.info
    end
  end


  private
    def set_new_date_after_add(time,hour, minutes)
      Time.new(time.year, time.month,time.day, hour, minutes, 0, nil)
    end

    def add_new_talk(talk)
      unless talk.duration == 5
        self.talks << talk
        talk.inside = true
        talk.time_event = self.actual_time
        new_time = self.actual_time + talk.duration * 60
        self.minutes_remaining -= talk.duration
        self.actual_time = Time.new(new_time.year, new_time.month,new_time.day, new_time.hour, new_time.strftime("%M"), 0, nil)
      end
    end

end