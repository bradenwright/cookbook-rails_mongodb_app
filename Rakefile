require 'rake'

desc 'Build MongoDB Database Nodes'
task :dbs, [:quantity] do |task, args|
  puts "Started at #{Time.now}"
  kit="bundle exec kitchen"
  IO.popen("#{kit} converge db -p", "w") { |pipe| puts pipe.gets rescue nil }
  (1..4).each do |i|
    IO.popen("lxc file pull db#{i}-ubuntu-1404/tmp/kitchen/nodes/db#{i}-ubuntu-1404.json .nodes", "w") { |pipe| puts pipe.gets rescue nil }
  end
  IO.popen("#{kit} converge db -p", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("#{kit} verify db -p", "w") { |pipe| puts pipe.gets rescue nil }
end

task :config do
  kit="bundle exec kitchen"
  IO.popen("#{kit} converge config -p", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("lxc file pull config-ubuntu-1404/tmp/kitchen/nodes/config-ubuntu-1404.json .nodes", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("#{kit} converge config -p", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("#{kit} verify config -p", "w") { |pipe| puts pipe.gets rescue nil }
end

task :mongos do
  kit="bundle exec kitchen"
  IO.popen("#{kit} converge mongos -p", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("lxc file pull mongos-ubuntu-1404/tmp/kitchen/nodes/mongos-ubuntu-1404.json .nodes", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("#{kit} verify mongos -p", "w") { |pipe| puts pipe.gets rescue nil }
end

task :webs do
  kit="bundle exec kitchen"
  IO.popen("#{kit} converge web -p", "w") { |pipe| puts pipe.gets rescue nil }
  (1..2).each do |i|
    IO.popen("lxc file pull web#{i}-ubuntu-1404/tmp/kitchen/nodes/web#{i}-ubuntu-1404.json .nodes", "w") { |pipe| puts pipe.gets rescue nil }
  end
  IO.popen("#{kit} verify web -p", "w") { |pipe| puts pipe.gets rescue nil }
end

task :lb do
  kit="bundle exec kitchen"
  IO.popen("#{kit} converge lb -p", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("lxc file pull lb-ubuntu-1404/tmp/kitchen/nodes/lb-ubuntu-1404.json .nodes", "w") { |pipe| puts pipe.gets rescue nil }
  IO.popen("#{kit} verify lb -p", "w") { |pipe| puts pipe.gets rescue nil }
end

task :proxy_install do
  kit="bundle exec kitchen"
  IO.popen("#{kit} create db1", "w") { |pipe| puts pipe.gets rescue nil } if !File.exists?("#{ENV['HOME']}/.lxd_proxy")
end

task :publish do
  kit="bundle exec kitchen"
  IO.popen("#{kit} verify base", "w") { |pipe| puts pipe.gets rescue nil }
  # Removing .ssh because converge was starting to quick and failng if .ssh files exist
  # If prefered you can set enable_wait_for_ssh_login to true
  IO.popen("lxc exec base-ubuntu-1404 bash", "w") do |pipe|
    pipe.puts("rm -rf /root/.ssh")
    puts pipe.gets rescue nil
    pipe.puts("exit")
  end
  IO.popen("#{kit} destroy base", "w") { |pipe| puts pipe.gets rescue nil }
end

task :converge => [:dbs, :config, :mongos, :webs, :lb] do
  kit="bundle exec kitchen"
end

task :setup => [:publish, :proxy_install] do
  puts "Finished at #{Time.now}"
end

task :destroy do
  kit="bundle exec kitchen"
  IO.popen("#{kit} destroy -p", "w") { |pipe| puts pipe.gets rescue nil }
  Dir[".nodes/*"].each do |file|
    File.delete(file) unless File.basename(file) == "README.md"
  end
end

task :default => [:verify]
