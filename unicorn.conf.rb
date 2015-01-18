working_directory ""
listen "/var/run/unicorn.sock", :backlog => 64
pid "/var/run/unicorn.pid"
stderr_path "/var/log/unicorn.stderr.log"
stdout_path "/var/log/unicorn.stdout.log"
