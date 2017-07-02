namespace :sample do
  desc "Test Parser"
  task parser: :environment do
  	SampleParser.parse_file
  end
end
