# UnixStats

CLI Unix hardware use monitor.

Currently, the following monitoring modules are implemented:
 - CPU
 - RAM
 - GPU**
 - Graphic RAM**

** GPU and Graphic RAM are only available for NVIDIA graphic cards.

# Quick how to:

> Start a interative terminal:
> > iex -S mix

> Run function UnixStats.measure/3
> 
> Arguments: time, visualization method (:pretty or :csv) and analyzing process name
> 
> example:
> > UnixStats.measure(60, :pretty, "beam.smp")