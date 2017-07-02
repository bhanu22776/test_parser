class SampleParser
  # parsing file from rake task
  def self.parse_file
    begin
      puts "Please enter file path..."
      file = STDIN.gets.chomp
      # file = "#{Rails.root}/public/sample-input.txt"
      f = File.open(file, 'r')
      byebug
      team_hash = {}
      f.each_line { |line|
        # get team and scores
        team1_score, team2_score = self.team_scores(line)

        # get team points
        team1_points = self.points(team1_score)
        team2_points = self.points(team2_score)

        # get team names
        team1_name = self.team_name(team1_score)
        team2_name = self.team_name(team2_score)

        team_hash[team1_name] ||= []
        team_hash[team2_name] ||= []

        # assigning points to the team
        if team1_points == team2_points
          team_hash[team1_name] << 1
          team_hash[team2_name] << 1
        elsif team1_points > team2_points
          team_hash[team1_name] << 3
          team_hash[team2_name] << 0
        else
          team_hash[team1_name] << 1
          team_hash[team2_name] << 1
        end
      }

      # calculate the team points
      team_hash.each{|k,v| team_hash[k] = v.inject(:+)}

      # create a new hash based on team points
      new_hash = team_hash.sort_by{|k,v| v}.reverse.to_h
      new_hash.each_with_index do |(k,v), i|
        puts "#{i+1}. #{k}, #{v} #{'pt'.pluralize(v)}"
      end
      # # save sample output in temp file
      # out_file = File.open('sample-output.txt', 'w')
      # new_hash.each_with_index do |(k,v), i|
      #   puts "#{i+1}. #{k}, #{v} #{'pt'.pluralize(v)}"
      #   out_file.write("#{i+1}. #{k}, #{v} #{'pt'.pluralize(v)} \n")
      # end
    rescue => ex
      puts "Invalid."
    end
  end

  def self.team_scores(line)
    team_score = line.split(',')
    return team_score.first.strip, team_score.last.strip
  end

  def self.points(score)
    score.split(" ").last.to_i
  end

  def self.team_name(score)
    team = score.split(" ")
    team.pop
    team.join(" ")
  end
end