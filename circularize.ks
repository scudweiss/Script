//circularize.ks
// circularizing manuver 

function circularize {
	lock throttle to 0.0. 
	until eta:apoapsis < 20.
	lock steering to prograde.
	until  periapsis > 75000 {
		print "circularizing" at (0,0).
		print "apoapsis:"  at (0,1).
		print apoapsis  at (0,2).
		print "periapsis:"  at (0,3).
		print periapsis  at (0,4).
		lock throttle to 1.0.
	}.
}