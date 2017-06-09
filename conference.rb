require 'pp'
Dir[__dir__ + '/model/*.rb'].each {|file| require file }

begin

    talks = Array.new
    File.open("input.txt", 'r') do |lines|
        while line = lines.gets
            talks << Talk.new(line.chomp) if Talk.valid?(line.chomp)
        end
    end

    i = 1;
    newTrack = true;
    begin
        if newTrack
            track = Track.new("Track "+i.to_s)
            newTrack = false
        end
        talks.each_with_index do |talk,index|
            if track.minutes_remaining > 0 && talk.duration > track.minutes_remaining
                talk = talks[index..-1].find{|t| t.duration == track.minutes_remaining}
            end
            track.add_talk(talk);
            if track.full?
                i += 1
                newTrack = true
                break
            end
        end
    end while talks.any?

    pp track
rescue Exception => ex
    puts ex.message
    puts 'An error has been discover, please, verify your file.'
end
