task :generate_missing_topentries => :environment do
  Topentry.generate_total_missing_entries(7)
end
