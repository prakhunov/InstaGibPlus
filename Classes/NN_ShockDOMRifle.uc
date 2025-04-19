// ===============================================================
// Stats.NN_ShockRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class NN_ShockDOMRifle extends NN_ShockRifle;

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local bbPlayer bbP;
	if (Owner.IsA('Bot'))
		return false;

	bbP = bbPlayer(Owner);
	if (bbP == none) return false;

	super.NN_ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);
	class'bbPlayerStatics'.static.PlayClientHitResponse(Pawn(Owner), Other, HitDamage, MyDamageType);
	
	return false;
}

function AltFire( float Value )
{
	return;
}

simulated function bool ClientAltFire(float Value)
{
	return false;
}

defaultproperties
{
	bNewNet=True
	PickupAmmoCount=50
	AmmoName=Class'ST_ShockCoreSDOM'
}