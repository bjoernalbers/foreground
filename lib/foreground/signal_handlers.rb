module Foreground
  [:TERM, :INT].each do |signal|
    trap(signal) do
      Daemon.kill(:TERM)
      exit
    end
  end
end
