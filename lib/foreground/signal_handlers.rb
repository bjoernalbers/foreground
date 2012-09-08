module Foreground
  [:TERM, :INT].each do |signal|
    trap(signal) do
      Daemon.kill(:TERM)
      exit
    end
  end

  trap(:HUP) do
    sleep 1
    Daemon.kill(:HUP)
  end
end
