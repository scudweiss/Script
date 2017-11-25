function land {
	set ship:control:pilotmainthrottle to 0.
	local target_twr is 0.
	lock g to body:mu / ((ship:altitude + body:radius)^2).
	lock maxtwr to ship:maxthrust / (g * ship:mass).
	lock throttle to min(target_twr / maxtwr, 1).
	brakes on.

	lock steering to (-1) * SHIP:VELOCITY:SURFACE.

	local pid is pidloop(2.7, 4.4, 0.12, 0, maxtwr).

	until SHIP:STATUS = "LANDED" OR SHIP:STATUS = "SPLASHED" {
		if ALT:RADAR < 30000 {
			if rcs rcs off.
			if ALT:RADAR > 10000 set pid:setpoint to -1000.
			else if ALT:RADAR > 5000 set pid:setpoint to -500.
			else if ALT:RADAR > 2000 set pid:setpoint to -200.
			else if ALT:RADAR > 1000 set pid:setpoint to -50.
			else if ALT:RADAR > 500 set pid:setpoint to -25.
			else if ALT:RADAR > 40 set pid:setpoint to -10.
			else if ALT:RADAR > 15 set pid:setpoint to -5.
			else if ALT:RADAR < 15 {
				set pid:setpoint to -1.
				panels off.
				gear on.
				lock steering to UP.
			}
			set pid:maxoutput to maxtwr.
			set target_twr to pid:update(TIME:SECONDS, ship:verticalspeed).
			clearscreen.
			print "landing...". 
			print ALT:RADAR.
		}
		wait 0.01.
	}
	brakes off.
	panels on.
	set ship:control:pilotmainthrottle to 0.
}

function launch {
	clearscreen.
	parameter dir.
	parameter targetalt.
	wait 1.
	lock throttle to 1.
	when maxthrust = 0 then {
	    set tmp to throttle.
	    lock throttle to 0.
	    stage.
	    preserve.
	    wait 0.5.
	    lock throttle to tmp.
	}.
	lock steering to heading (dir,90).
	until apoapsis >= targetalt {
		when ship:velocity:surface:mag > 100 then { 
			lock x to ((ship:altitude)).
			print "apoapsis:"  at (0,0).
			print apoapsis  at (0,1).
			print "periapsis:"  at (0,2).
			print periapsis  at (0,3).
			if x < 2000{
				lock steering to heading (dir,80).
			} else if x > 2000 and x < 4000 {
				AG3 ON.
				lock steering to heading (dir,70).
			} else if x > 4000 and x < 6000 {
				lock steering to heading (dir,60).
			} else if x > 6000 and x < 8000 {
				lock steering to heading (dir,50).
			} else if x > 8000 and x < 10000 {
				lock steering to heading (dir,40).
			} else if x > 10000 and x < 12000 {
				lock steering to heading (dir,35).
			} else if x > 12000 and x < 14000 {
				lock steering to heading (dir,30).
			} else if x > 14000 and x < 16000 {
				lock steering to heading (dir,25).
			} else if x > 16000 and x < 20000 {
				lock steering to heading (dir,20).
			} else if x > 60000 {
				lock throttle to 0.5.  
				lock steering to prograde.
			} else  {
				lock throttle to 0.75.  
				lock steering to heading (dir,20).
			}.
		}.	
	}.
	lock throttle to 0.
	wait 1.
}

launch(90,20000).
land().
