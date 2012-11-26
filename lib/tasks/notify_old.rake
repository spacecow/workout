task :notify_old => :environment do
  Comment.notify_old
end
