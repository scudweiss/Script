//launch
//first, we'll clear the terminal screen to make it look nice

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
			if x < 2000 lock steering to heading (dir,80).
			else if x > 2000 and x < 4000 lock steering to heading (dir,70).
			else if x > 4000 and x < 8000 lock steering to heading (dir,60).
			else if x > 8000 and x < 12000 lock steering to heading (dir,50).
			else if x > 12000 and x < 20000 lock steering to heading (dir,40).
			else if x > 20000 and x < 30000 {
				lock steering to heading (dir,30).
			} else if x > 30000 {
				lock throttle to 0.5. 
				lock steering to prograde.
			}.
		}.	
	}.
	lock throttle to 0. 
	lock steering to prograde. 
	if targetalt > 70000{
		until altitude > 70000 {
			if apoapsis < targetalt lock throttle to 0.1.
			else lock throttle to 0.
		}
	}
	lock throttle to 0.
	wait 1.
}

function circularize {
	lock throttle to 0.
	lock time to ETA:APOAPSIS.
	set myNode to NODE(0, 0, 0, 0).
	ADD myNode.
	set pro to 0.
	until myNode:Orbit:ECCENTRICITY < 0.3 {
		print myNode:Orbit:ECCENTRICITY.
		REMOVE myNode.
		set myNode:prograde to pro.
		set myNode:ETA to time.
		set pro to pro + 100.
		ADD myNode.
	}
	until myNode:Orbit:ECCENTRICITY < 0.1 {
		print myNode:Orbit:ECCENTRICITY.
		REMOVE myNode.
		set myNode:prograde to pro.
		set myNode:ETA to time.
		set pro to pro + 50.
		ADD myNode.
	}
	until myNode:Orbit:ECCENTRICITY < 0.05 {
		print myNode:Orbit:ECCENTRICITY.
		REMOVE myNode.
		set myNode:prograde to pro.
		set myNode:ETA to time.
		set pro to pro + 10.
		ADD myNode.
	}
	until myNode:Orbit:ECCENTRICITY < 0.01 {
		print myNode:Orbit:ECCENTRICITY.
		REMOVE myNode.
		set myNode:prograde to pro.
		set myNode:ETA to time.
		set pro to pro + 1.
		ADD myNode.
	}
	until myNode:Orbit:ECCENTRICITY < 0.001 {
		print myNode:Orbit:ECCENTRICITY.
		REMOVE myNode.
		set myNode:prograde to pro.
		set myNode:ETA to time.
		set pro to pro + 0.1.
		ADD myNode.
	}
	exec_node().
}

function deorbit {
	print "deorbiting...".
	wait until eta:apoapsis < 30.
	lock steering to retrograde.
	lock throttle to 0.3.
	wait until periapsis < -100000 OR ship:liquidfuel < 0.5. 
	lock throttle to 0.
	brakes on.
}

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
			else if ALT:RADAR > 15 set pid:setpoint to -100.
			else if ALT:RADAR < 15 {
				set pid:setpoint to -1.
				panels off.
				gear on.
				lock steering to UP.
			}
			set pid:maxoutput to maxtwr.
			set target_twr to pid:update(TimeSpan:time:seconds, ship:verticalspeed).
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

function exec_node {
	print "executing node". 
	set nd to nextnode.
	set max_acc to ship:maxthrust/ship:mass.
	set burn_duration to nd:deltav:mag/max_acc.
	print "Crude Estimated burn duration: " + round(burn_duration) + "s".
	set kuniverse:Timewarp:mode to "rails".
	set kuniverse:Timewarp:warp to 10.
	wait until nd:eta <= (burn_duration/2 + 60).
	set kuniverse:Timewarp:warp to 0.
	lock np to nd:deltav.
	lock steering to np.
	wait until nd:eta <= (burn_duration/2).
	set tset to 0.
	lock throttle to tset.
	set done to False.
	set dv0 to nd:deltav.
	until done {
		set max_acc to ship:maxthrust/ship:mass.
		set tset to min(nd:deltav:mag/max_acc, 1).
		if vdot(dv0, nd:deltav) < 0 {
			print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        	lock throttle to 0.
        	set done to True.
		} 
		if nd:deltav:mag < 0.1 {
			print "Finalizing burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
			wait until vdot(dv0, nd:deltav) < 0.5.
			lock throttle to 0.
        	print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        	set done to True.
		}
	}
	unlock steering.
	unlock throttle.
	wait 1.
	REMOVE nd.
}