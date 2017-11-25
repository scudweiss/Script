//boot
copypath("0:/manuver.ks","").
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
set ship:control:pilotmainthrottle to 0.
run manuver.
launch(90, 80000).
lock throttle to 0.
AG4 ON.
if KUniverse:canQuickSave() KUniverse:QuickSave().
wait until altitude > 70000.
rcs on.
circularize().
unlock steering. 
if KUniverse:canQuickSave() KUniverse:QuickSave().
wait 10. 
stage.
wait 10.
deorbit().
if KUniverse:canQuickSave() KUniverse:QuickSave().
AG3 ON. 
land().