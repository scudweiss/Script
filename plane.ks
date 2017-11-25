clearscreen. 
lock throttle to 1. 
set brakes to false.
wait 1.
stage.
until altitude > 30000 {
	if ship:velocity:surface:mag < 70 {
		lock throttle to 1. 
		lock steering to heading (90,0).
	} else {
		if altitude > 300 {
			set gear to false.
		}.
		if altitude < 10000 {
			lock steering to heading (90,30).
		} else {
			lock steering to heading (90,10).
		}.
		lock throttle to 1.
	}.
	wait 0.5.
}.