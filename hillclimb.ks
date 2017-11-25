//Hillclimbing for manuver nodes
function hillclimb {
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
}
