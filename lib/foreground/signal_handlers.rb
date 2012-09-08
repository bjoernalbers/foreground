module Foreground
  trap(:TERM) do
    Daemon.kill(:TERM)
    exit
  end
end
