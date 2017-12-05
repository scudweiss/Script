//boot
copypath("0:/manuver.ks","").
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
run manuver.
set ship:control:pilotmainthrottle to 0.
lights on.
if altitude < 70000 {
	launch (90, 75000).
	lock throttle to 0.
	lock steering to prograde.
	wait until eta:apoapsis > 20.
	kuniverse:quicksave.
	lock trottle to 1.
	wait 5.	
}
lock throttle to 0.
wait 1.
breaks on.
rcs on.
local target_twr is 0.
lock g to body:mu / ((ship:altitude + body:radius)^2).
lock maxtwr to ship:maxthrust / (g * ship:mass).
lock throttle to min(target_twr / maxtwr, 1).

lock steering to (-1) * SHIP:VELOCITY:SURFACE.

local pid is pidloop(2.7, 4.4, 0.12, 0, maxtwr).
set pid:setpoint to 0.

until SHIP:STATUS = "LANDED" OR SHIP:STATUS = "SPLASHED" {
	if ALT:RADAR > 10000 set pid:setpoint to -1000.
	else if ALT:RADAR > 5000 set pid:setpoint to -500.
	else if ALT:RADAR > 2000 set pid:setpoint to -200.
	else if ALT:RADAR > 500 set pid:setpoint to -100.
	else if ALT:RADAR > 200 set pid:setpoint to -50.
	else if ALT:RADAR > 50 set pid:setpoint to -10.
	else if ALT:RADAR > 25 set pid:setpoint to -5.
	else if ALT:RADAR > 15 set pid:setpoint to -3.
	else if ALT:RADAR < 15 {
		set pid:setpoint to -1.
		panels off.
		gear on.
		lock steering to UP.
	}
	set pid:maxoutput to maxtwr.
	set target_twr to pid:update(time:seconds, ship:verticalspeed).
	wait 0.01.
}
brakes off.
set ship:control:pilotmainthrottle to 0.