//Launch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.
FUNCTION LAUNCH {
	PARAMETER DIR.
	PARAMETER TARGETALT.
	//Next, we'll lock our throttle to 100%.
	LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.
	WAIT 1.
	WHEN MAXTHRUST = 0 THEN {
	    LOCK THROTTLE TO 0.
	    STAGE.
	    PRESERVE.
	    WAIT 0.5.
	    LOCK THROTTLE TO 1.
	}.
	LOCK STEERING TO HEADING (DIR,90).
	UNTIL APOAPSIS >=TARGETALT {
		WHEN SHIP:VELOCITY:SURFACE:MAG > 100 THEN {
			LOCK X TO ((SHIP:ALTITUDE)).
			PRINT "APOAPSIS:"  AT (0,0).
			PRINT APOAPSIS  AT (0,1).
			PRINT "PERIAPSIS:"  AT (0,2).
			PRINT PERIAPSIS  AT (0,3).
			IF X < 2000{
				LOCK STEERING TO HEADING (DIR,85).
			} ELSE IF X > 2000 AND X < 4000 {
				LOCK STEERING TO HEADING (DIR,80).
			} ELSE IF X > 4000 AND X < 6000 {
				LOCK STEERING TO HEADING (DIR,75).
			} ELSE IF X > 6000 AND X < 8000 {
				LOCK STEERING TO HEADING (DIR,70).
			} ELSE IF X > 8000 AND X < 10000 {
				LOCK STEERING TO HEADING (DIR,75).
			} ELSE IF X > 10000 AND X < 12000 {
				LOCK STEERING TO HEADING (DIR,60).
			} ELSE IF X > 12000 AND X < 14000 {
				LOCK STEERING TO HEADING (DIR,65).
			} ELSE IF X > 14000 AND X < 16000 {
				LOCK STEERING TO HEADING (DIR,50).
			} ELSE IF X > 16000 AND X < 20000 {
				LOCK STEERING TO HEADING (DIR,45).
			} ELSE  {  
				LOCK STEERING TO PROGRADE.
			}.
		}.	
	}.
}.

FUNCTION CIRCULARIZE {
	LOCK THROTTLE TO 0.0.
	
	UNTIL ETA:APOAPSIS < 40{
		set kuniverse:timewarp:mode to "PHYSICS".
		set kuniverse:timewarp:rate to 3.
		WAIT 5.
		CANCELWARP(). 
	}
	UNTIL ETA:APOAPSIS < 20.
	SET STEERING TO PROGRADE.
	UNTIL  PERIAPSIS > 75000 {
		PRINT "CIRCULARIZING" AT (0,0).
		PRINT "APOAPSIS:"  AT (0,1).
		PRINT APOAPSIS  AT (0,2).
		PRINT "PERIAPSIS:"  AT (0,3).
		PRINT PERIAPSIS  AT (0,4).
		LOCK THROTTLE TO 1.0.
	}.

	LOCK THROTTLE TO 0.0.
	CLEARSCREEN.
	PRINT "LAUNCH COMPLETE COMPLETE".
	PRINT "APOAPSIS:".
	PRINT APOAPSIS.
	PRINT "PERIAPSIS:".
	PRINT PERIAPSIS.
	PRINT "RETURNING CONTROL TO PILOT IN:".
	PRINT "3".
	WAIT 1.
	PRINT "2".
	WAIT 1.
	PRINT "1".
	WAIT 1.
	PRINT "PILOT CONTROL RESTORED:".
	SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
	PRINT "TROTTLE SET TO 0.0".
}.

FUNCTION DEORBIT {
	UNTIL ETA:APOAPSIS < 60 {
		set kuniverse:timewarp:mode to "RAILS".
		set kuniverse:timewarp:rate to 1000.
	}
	CANCELWARP().
	UNTIL ETA:APOAPSIS < 20.
	UNTIL PERIAPSIS < 30000 {
		LOCK STEERING TO RETROGRADE. 
		LOCK THROTTLE TO 1.0.
	}.
	WAIT 1.
	LOCK STEEERING TO RETROGRADE.
	UNTIL SHIP:STAGE = 0 {
		STAGE.
	}.
}.

LAUNCH (90,80000).
CIRCULARIZE().
DEORBIT().
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.