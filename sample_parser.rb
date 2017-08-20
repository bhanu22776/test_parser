class SampleParser
  # parsing file from rake task
  def parse_file
    begin
      puts "Please enter file path..."
      file_path = STDIN.gets.chomp
      f = File.open(file_path, 'r')
      team_hash = {}
      f.each_line { |line|
        # get team and scores
        team1_score, team2_score = team_scores(line)

        # get team points
        team1_points, team2_points = points(team1_score), points(team2_score)

        # get team names
        team1_name, team2_name = team_name(team1_score), team_name(team2_score)

        team_hash[team1_name] ||= []
        team_hash[team2_name] ||= []

        # assigning points to the team
        team_hash = add_points_to_team(team_hash, team1_name, team2_name, team1_points, team2_points)
      }

      # calculate the team points
      team_hash.each{|k,v| team_hash[k] = v.inject(:+)}

      # create a new hash based on team points
      new_hash = team_hash.sort_by{|k,v| v}.reverse.to_h
      new_hash.each_with_index do |(k,v), i|
        puts "#{i+1}. #{k}, #{pluralize(v)}"
      end
    rescue => ex
      puts ex
    end
  end

  private
  def team_scores(line)
    team_score = line.split(',')
    return team_score.first.strip, team_score.last.strip
  end

  def points(score)
    score.split(" ").last.to_i
  end

  def team_name(score)
    team = score.split(" ")
    team.pop
    team.join(" ")
  end

  def add_points_to_team(hash, name1, name2, points1, points2)
    if points1 == points2
      hash[name1] << 1
      hash[name2] << 1
    elsif points1 > points2
      hash[name1] << 3
      hash[name2] << 0
    else
      hash[name1] << 1
      hash[name2] << 1
    end
    hash
  end

	def pluralize(n)
    if n == 1
      "#{n} pt"
    else
      "#{n} pts"
    end
	end
end

obj = SampleParser.new
obj.parse_file