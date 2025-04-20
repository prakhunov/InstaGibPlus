class ShockRifleSDOMWeaponEffect extends WeaponEffect
	abstract;

static function Play(
	PlayerPawn Player,
	ClientSettings Settings,
	PlayerReplicationInfo SourcePRI,
	vector SourceLocation,
	vector SourceOffset,
	Actor Target,
	vector TargetLocation,
	vector TargetOffset,
	vector HitNormal
) {
	local vector SmokeLocation;
	local vector HitLocation;

	if (Player.Level.NetMode == NM_DedicatedServer) return;

	if (SourcePRI.Owner != none && Settings.BeamOriginMode == 1) {
		SmokeLocation = GetPlayerLocation(SourcePRI.Owner) + SourceOffset;
	} else {
		SmokeLocation = SourceLocation;
	}

	if (Target != none && Settings.BeamDestinationMode == 1) {
		HitLocation = GetPlayerLocation(Target) + TargetOffset;
	} else {
		HitLocation = TargetLocation;
	}

	PlayBeam(Player, Settings, SourcePRI, SmokeLocation, HitLocation, HitNormal);
}

static function PlayBeam(
	PlayerPawn Player,
	ClientSettings Settings,
	PlayerReplicationInfo SourcePRI,
	vector SmokeLocation,
	vector HitLocation,
	vector HitNormal
) {
	local ClientShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;
	local vector MoveAmount;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector) / 135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	if (Settings.cShockBeam == 3) return;
	if (Settings.bHideOwnBeam &&
		(SourcePRI.Owner == Player || SourcePRI.Owner == Player.ViewTarget) &&
		Player.bBehindView == false)
		return;

	Smoke = class'ClientShockBeam'.static.AllocBeam(Player);
	if (Smoke == none) return;
	Smoke.SetLocation(SmokeLocation);
	Smoke.SetRotation(SmokeRotation);
	MoveAmount = DVector / NumPoints;

	if (Settings.cShockBeam == 1) {
		Smoke.SetProperties(
			-1,
			1,
			1,
			0.27,
			MoveAmount,
			NumPoints - 1,
			Settings.bBeamEnableLight);

	} else if (Settings.cShockBeam == 2) {
		Smoke.SetProperties(
			SourcePRI.Team,
			Settings.BeamScale,
			Settings.BeamFadeCurve,
			Settings.BeamDuration,
			MoveAmount,
			NumPoints - 1,
			Settings.bBeamEnableLight);

	} else if (Settings.cShockBeam == 4) {
		Smoke.SetProperties(
			SourcePRI.Team,
			Settings.BeamScale,
			Settings.BeamFadeCurve,
			Settings.BeamDuration,
			MoveAmount,
			0,
			Settings.bBeamEnableLight);

		for (NumPoints = NumPoints - 1; NumPoints > 0; NumPoints--) {
			SmokeLocation += MoveAmount;
			Smoke = class'ClientShockBeam'.static.AllocBeam(Player);
			if (Smoke == None) break;
			Smoke.SetLocation(SmokeLocation);
			Smoke.SetRotation(SmokeRotation);
			Smoke.SetProperties(
				SourcePRI.Team,
				Settings.BeamScale,
				Settings.BeamFadeCurve,
				Settings.BeamDuration,
				MoveAmount,
				0,
				Settings.bBeamEnableLight);
		}
	}
}