require 'pp'
Dir[__dir__ + '/model/*.rb'].each {|file| require file }

begin

    talks = Array.new
    File.open("input.txt", 'r') do |lines|
        while line = lines.gets
            talks << Talk.new(line.chomp) if Talk.valid?(line.chomp)
        end
    end

    talks.sort!{ |t1, t2| t2.duration <=> t1.duration }

    i = 1;
    newTrack = true;
    begin
        if newTrack
            track = Track.new("Track "+i.to_s)
            newTrack = false
        end
        talks.each do |talk|
            if talk.duration <= track.minutes_remaining
                track.add_talk(talk);
            end
            if track.full?
                i += 1
                newTrack = true
                talks.delete_if{|t| t.inside}
                track.info
                break
            elsif talks.last.duration == talk.duration
                track.talks << Talk.new(talk.title,'lightning', track.actual_time)
                talk.inside = true
                track.minutes_remaining = 0
                track.actual_time = track.end_time
                track.talks << Talk.new("Networking Event", 0, track.actual_time)
                talks.delete_if{|t| t.inside}
                track.info
                break
            end
        end
    end while talks.any?

rescue Exception => ex
    puts ex.message
    puts 'An error has been discover, please, verify your file.'
end
