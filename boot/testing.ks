//boot
copypath("0:/manuver.ks","").
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
set ship:control:pilotmainthrottle to 0.
lights on.
run manuver.
launch(90, 80000).
lock throttle to 0.
wait until altitude > 70000.
kuniverse:quicksave.
AG3 ON.
rcs on.
if orbit:ECCENTRICITY > 0.001 circularize().
AG2 ON.  
stage.
wait 5. 
unlock steering. 
AG1 ON.
wait 1.
deorbit().
land().
