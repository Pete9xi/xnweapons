ESX                           = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
--Setup Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
			for i = 1, #v.Locations, 1 do
				local blip = AddBlipForCoord(v.Locations[i])

				SetBlipSprite (blip, 110)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.7)
				SetBlipColour (blip, 81)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(('Ammu-Nation'))
				EndTextCommandSetBlipName(blip)
			end
	end
end)

local xnWeapons = xnWeapons or {
    interiorIDs = {
        [153857] = true,
        [200961] = true,
		[140289] = {
			weaponRotationOffset = 135.0,
		},
        [180481] = true,
        [168193] = true,
        [164609] = {
			weaponRotationOffset = 150.0,
		},
        [175617] = true,
        [176385] = true,
		[178689] = true,
		[137729] = {
			additionalOffset = 			vec(8.3,-6.5,0.0),
			additionalCameraOffset = 	vec(8.3,-6.0,0.0),
			additionalCameraPoint = 	vec(1.0,-0.91,0.0),
			additionalWeaponOffset =	vec(0.0,0.5,0.0),
			weaponRotationOffset = 		-60.0,
		},
		[248065] = {
			additionalOffset = 			vec(-10.0,3.0,0.0),
			additionalCameraOffset = 	vec(-9.5,3.0,0.0),
			additionalCameraPoint = 	vec(-1.0,0.4,0.0),
			additionalWeaponOffset =	vec(0.4,0.0,0.0),
		},
    },
    closeMenuNextFrame = false,
    weaponClasses = {},
}
function IsAmmunationOpen()
	return (string.find(tostring(JayMenu.CurrentMenu() or ""), "xnweapons") or string.find(tostring(JayMenu.CurrentMenu() or ""), "xnw_"))
end

local globalWeaponTable = {
    {
        name = "Melee",
        { 'WEAPON_KNUCKLE', 'Knuckle Dusters','100' },
        { 'WEAPON_SWITCHBLADE', 'Switchblade','90' },
        { 'WEAPON_KNIFE', 'Knife','30' },
        { 'WEAPON_NIGHTSTICK', 'Nightstick','50' },
        { 'WEAPON_HAMMER', 'Hammer','9' },
        { 'WEAPON_BAT', 'Katana','10' },
        { 'WEAPON_GOLFCLUB', 'Golf Club','0' },
        { 'WEAPON_CROWBAR', 'Crow Bar','20' },
        { 'WEAPON_HATCHET', 'Hatchet','30' },
        { 'WEAPON_POOLCUE', 'Pool Cue','0' },
        { 'WEAPON_WRENCH', 'Wrench','4' },
        { 'WEAPON_FLASHLIGHT', 'Flashlight','10' },
        { 'WEAPON_BOTTLE', 'Broken Bottle','0' },
        { 'WEAPON_DAGGER', 'Bowie Knife','25' },
        { 'WEAPON_MACHETE', 'Machete','50' },
        { 'WEAPON_BATTLEAXE', 'Battle Axe','39' },
        { 'WEAPON_BALL', 'Baseball','5' },
        { 'WEAPON_SNOWBALL', 'Snowball','0' },
    },
    {
        name = "Pistols",
        { 'WEAPON_PISTOL', 'Pistol','250' },
        { 'WEAPON_PISTOL_MK2', 'Pistol MKII','2500' },
        { 'WEAPON_COMBATPISTOL', 'Combat Pistol','320' },
        { 'WEAPON_MACHINEPISTOL', 'Machine Pistol','650' },
        { 'WEAPON_APPISTOL', 'Automatic Pistol','500' },
        { 'WEAPON_PISTOL50', 'Pistol .50','390' },
        { 'WEAPON_REVOLVER', 'Revolver','590' },
        { 'WEAPON_REVOLVER_MK2', 'Revolver MKII','2590' },
        { 'WEAPON_VINTAGEPISTOL', 'Vintage Pistol','450' },
        { 'WEAPON_SNSPISTOL', 'SNS Pistol','575' },
        { 'WEAPON_SNSPISTOL_MK2', 'SNS Pistol MKII','1575' },
        { 'WEAPON_MARKSMANPISTOL', 'Marksman Pistol','350' },
        { 'WEAPON_HEAVYPISTOL', 'Heavy Pistol','750' },
        { 'WEAPON_FLAREGUN', 'Flare Gun','150' },
        { 'WEAPON_STUNGUN', 'Taser','250' },
        { 'WEAPON_DOUBLEACTION', 'Double-Action Revolver','2999' },
    },
    {
        name = "SMGs",
        { 'WEAPON_MICROSMG', 'Micro SMG','500' },
        { 'WEAPON_SMG', 'SMG','750' },
        { 'WEAPON_SMG_MK2', 'SMG MKII','1750' },
        { 'WEAPON_ASSAULTSMG', 'Assault SMG','1200' },
        { 'WEAPON_MINISMG', 'Mini SMG','900' },
        { 'WEAPON_COMBATPDW', 'Combat PDW','1720' },
    },
    {
        name = "MGs",
        { 'WEAPON_MG', 'MG','3500' },
        { 'WEAPON_COMBATMG', 'Combat MG','4800' },
        { 'WEAPON_COMBATMG_MK2', 'Combat MG MKII','9000' },
        { 'WEAPON_GUSENBERG', 'Gusenberg','4600' },
    },
    {
        name = "Shotguns",
        { 'WEAPON_PUMPSHOTGUN', 'Pump Shotgun','1500' },
        { 'WEAPON_PUMPSHOTGUN_MK2', 'Pump Shotgun MKII','2500' },
        { 'WEAPON_HEAVYSHOTGUN', 'Heavy Shotgun','3509' },
        { 'WEAPON_SAWNOFFSHOTGUN', 'Sawn-off Shotgun','500' },
        { 'WEAPON_ASSAULTSHOTGUN', 'Assault Shotgun','2000' },
        { 'WEAPON_BULLPUPSHOTGUN', 'Bullpup Shotgun','1000' },
        { 'WEAPON_AUTOSHOTGUN', 'Sweeper','3000' },
        { 'WEAPON_DBSHOTGUN', 'Double-Barreled Shotgun','1590' },
        { 'WEAPON_MUSKET', 'Musket','1000' },
    },
    {
        name = "Assault Rifles",
        { 'WEAPON_ASSAULTRIFLE', 'Assault Rifle','1000' },
        { 'WEAPON_ASSAULTRIFLE_MK2', 'Assault Rifle MKII','2500' },
        { 'WEAPON_CARBINERIFLE', 'Carbine Rifle','3000' },
        { 'WEAPON_CARBINERIFLE_MK2', 'Carbine Rifle MKII','4000' },
        { 'WEAPON_ADVANCEDRIFLE', 'Advanced Rifle','4250' },
        { 'WEAPON_COMPACTRIFLE', 'Compact Rifle','4650' },
        { 'WEAPON_SPECIALCARBINE', 'Special Carbine','4750' },
        { 'WEAPON_SPECIALCARBINE_MK2', 'Special Carbine MKII','8750' },
        { 'WEAPON_BULLPUPRIFLE', 'Bullpup Rifle','4500' },
        { 'WEAPON_BULLPUPRIFLE_MK2', 'Bullpup Rifle MKII','5000' },
    },
    {
        name = "Sniper Rifles",
        { 'WEAPON_SNIPERRIFLE', 'Sniper Rifle','2000' },
        { 'WEAPON_HEAVYSNIPER', 'Heavy Sniper Rifle','2990' },
        { 'WEAPON_HEAVYSNIPER_MK2', 'Heavy Sniper Rifle MKII','3900' },
        { 'WEAPON_MARKSMANRIFLE', 'Marksman Rifle','5750' },
        { 'WEAPON_MARKSMANRIFLE_MK2', 'Marksman Rifle MKII','6750' },
    },
    {
        name = "Special Weapons",
        { 'WEAPON_COMPACTLAUNCHER', 'Compact Grenade Launcher','3000' },
        { 'WEAPON_GRENADELAUNCHER', 'Grenade Launcher','2500' },
        { 'WEAPON_RPG', 'RPG','2580' },
        { 'WEAPON_HOMINGLAUNCHER', 'Homing Launcher','5000' },
        { 'WEAPON_MINIGUN', 'Minigun','7000' },
        { 'WEAPON_RAILGUN', 'Railgun','10000' },
		{ 'WEAPON_RAYMINIGUN', 'Widowmaker','100000' },
		{ 'WEAPON_RAYCARBINE', 'Un Holy Hailbringer','120000' },
		
    },
    {
        name = "Throwables",
        { 'WEAPON_GRENADE', 'Frag Grenade', {noTint = true},'250' },
        { 'WEAPON_STICKYBOMB', 'Sticky Bombs', {noTint = true},'600' },
        { 'WEAPON_SMOKEGRENADE', 'Smoke Grenade', {noTint = true},'500' },
        { 'WEAPON_BZGAS', 'BZ Gas', {noTint = true},'300' },
        { 'WEAPON_MOLOTOV', 'Molotov Cocktail', {noTint = true},'150' },
        { 'WEAPON_PIPEBOMB', 'Pipebomb', {noTint = true},'500' },
        { 'WEAPON_PROXMINE', 'Proximity Mine', {noTint = true},'750' },
    },
    {
        name = "Accessories",
        { 'WEAPON_FIREEXTINGUISHER', 'Fire Extinguisher', {noAmmo = true, noTint = true},'100' },
        { 'WEAPON_FIREWORK', 'Firework Launcher', {noTint = true},'200' },
        { 'WEAPON_PETROLCAN', 'Jerry Can', {noTint = true},'50' },
		{ 'WEAPON_FLARE', 'Flare', {noTint = true},'90' },
		{ 'GADGET_PARACHUTE', 'Parachute', {noPreview = true, noTint = true, noAmmo = true},'500' },
    },
}
local globalAttachmentTable = {  
	-- Putting these at the top makes them work properly as they need to be applied to the weapon first before other attachments
	{ "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_CARBINERIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_MICROSMG_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_SNIPERRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_PISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_PISTOL50_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_APPISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_SMG_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },
	{ "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish",'150' },

	{ "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_MG_COMBATMG_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_BULLPUPRIFLE_VARMOD_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_MG_VARMOD_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER", "Lowrider Finish",'150' },
	{ "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", "Lowrider Finish",'150' },

	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_02", "Extended Magazine",'200'},
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_COMBATMG_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_SMG_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_PISTOL_MK2_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_PISTOL_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_ASSAULTSHOTGUN_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_HEAVYSHOTGUN_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_PISTOL50_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_COMBATPISTOL_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_APPISTOL_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_COMBATPDW_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_SNSPISTOL_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_02", "Extended Magazine",'200'},
	{ "COMPONENT_ASSAULTRIFLE_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_COMBATMG_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_MG_CLIP_02", "Extended Magazine",'200'},
	{ "COMPONENT_ASSAULTSMG_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_GUSENBERG_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_MICROSMG_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_BULLPUPRIFLE_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_COMPACTRIFLE_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_HEAVYPISTOL_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_VINTAGEPISTOL_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_CARBINERIFLE_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_ADVANCEDRIFLE_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_MARKSMANRIFLE_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_SMG_CLIP_02", "Extended Magazine",'200' },
	{ "COMPONENT_SPECIALCARBINE_CLIP_02", "Extended Magazine" },

	{ "COMPONENT_SPECIALCARBINE_CLIP_03", "Drum Magazine",'200' },
	{ "COMPONENT_COMPACTRIFLE_CLIP_03", "Drum Magazine" ,'200'},
	{ "COMPONENT_COMBATPDW_CLIP_03", "Drum Magazine",'200' },
	{ "COMPONENT_ASSAULTRIFLE_CLIP_03", "Drum Magazine",'200' },
	{ "COMPONENT_HEAVYSHOTGUN_CLIP_03", "Drum Magazine",'200' },
	{ "COMPONENT_CARBINERIFLE_CLIP_03", "Drum Magazine",'200' },
	{ "COMPONENT_SMG_CLIP_03", "Drum Magazine",'200' },

	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'350' },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'350' },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'350' },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_PISTOL_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_PISTOL_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_PISTOL_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'350' },
	{ "COMPONENT_PISTOL_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds",'350' },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE", "Explosive Rounds",'400' },

	{ "COMPONENT_SNSPISTOL_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds",'350' },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_REVOLVER_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds",'350' },
	{ "COMPONENT_REVOLVER_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_SMG_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_SMG_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_SMG_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'350' },
	{ "COMPONENT_SMG_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER", "Tracer Rounds",'300' },
	{ "COMPONENT_COMBATMG_MK2_CLIP_TRACER", "Tracer Rounds",'350' },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_TRACER", "Tracer Rounds",'400' },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'300' },
	{ "COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'350' },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY", "Incendiary Rounds",'400' },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'300' },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'300' },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'350' },
	{ "COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds",'400' },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'300' },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'300' },
	{ "COMPONENT_COMBATMG_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'350' },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ", "Full Metal Jacket Rounds",'400' },

	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE", "Explosive Rounds",'450' },

	{ "COMPONENT_AT_PI_FLSH_02", "Flashlight",'50' },
	{ "COMPONENT_AT_AR_FLSH	", "Flashlight",'50' },
	{ "COMPONENT_AT_PI_FLSH", "Flashlight",'50' },
	{ "COMPONENT_AT_AR_FLSH", "Flashlight",'50' },
	{ "COMPONENT_AT_PI_FLSH_03", "Flashlight",'50' },

	{ "COMPONENT_AT_PI_SUPP", "Suppressor", '400' },
	{ "COMPONENT_AT_PI_SUPP_02", "Suppressor", '400' },
	{ "COMPONENT_AT_AR_SUPP", "Suppressor", '400' },
	{ "COMPONENT_AT_AR_SUPP_02", "Suppressor", '400' },
	{ "COMPONENT_AT_SR_SUPP", "Suppressor", '400' },
	{ "COMPONENT_AT_SR_SUPP_03", "Suppressor", '400' },

	{ "COMPONENT_AT_PI_COMP", "Compensator",'150' },
	{ "COMPONENT_AT_PI_COMP_02", "Compensator",'150' },
	{ "COMPONENT_AT_PI_COMP_03", "Compensator",'150' },
	{ "COMPONENT_AT_MRFL_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_MRFL_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_SR_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_BP_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_BP_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_SC_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_SC_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_AR_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_SB_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_CR_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_MG_BARREL_01", "Barrel Attachment 1", '60' },
	{ "COMPONENT_AT_MG_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_CR_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_SR_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_SB_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_AR_BARREL_02", "Barrel Attachment 2", '60' },
	{ "COMPONENT_AT_MUZZLE_01", "Muzzle Attachment 1", '90' },
	{ "COMPONENT_AT_MUZZLE_02", "Muzzle Attachment 2", '90' },
	{ "COMPONENT_AT_MUZZLE_03", "Muzzle Attachment 3", '90' },
	{ "COMPONENT_AT_MUZZLE_04", "Muzzle Attachment 4", '90' },
	{ "COMPONENT_AT_MUZZLE_05", "Muzzle Attachment 5", '90' },
	{ "COMPONENT_AT_MUZZLE_06", "Muzzle Attachment 6", '90' },
	{ "COMPONENT_AT_MUZZLE_07", "Muzzle Attachment 7", '90' },

	{ "COMPONENT_AT_AR_AFGRIP", "Grip", '100' },
	{ "COMPONENT_AT_AR_AFGRIP_02", "Grip", '100' },

	{ "COMPONENT_AT_PI_RAIL", "Holographic Sight", '120' },
	{ "COMPONENT_AT_SCOPE_MACRO_MK2", "Holographic Sight", '120' },
	{ "COMPONENT_AT_PI_RAIL_02", "Holographic Sight", '120' },
	{ "COMPONENT_AT_SIGHTS_SMG", "Holographic Sight", '120' },
	{ "COMPONENT_AT_SIGHTS", "Holographic Sight", '120' },

	{ "COMPONENT_AT_SCOPE_SMALL", "Scope Small", '200' },
	{ "COMPONENT_AT_SCOPE_SMALL_02", "Scope Small", '200' },

	{ "COMPONENT_AT_SCOPE_MACRO_02", "Scope",'200' },
	{ "COMPONENT_AT_SCOPE_SMALL_02", "Scope",'200' },
	{ "COMPONENT_AT_SCOPE_MACRO", "Scope",'200' },
	{ "COMPONENT_AT_SCOPE_MEDIUM", "Scope",'200' },
	{ "COMPONENT_AT_SCOPE_LARGE", "Scope",'200' },
	{ "COMPONENT_AT_SCOPE_SMALL", "Scope",'200' },

	{ "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2", "2x Scope",'250' },
	{ "COMPONENT_AT_SCOPE_SMALL_MK2", "2x Scope",'250' },

	{ "COMPONENT_AT_SCOPE_SMALL_SMG_MK2", "4x Scope",'350' },
	{ "COMPONENT_AT_SCOPE_MEDIUM_MK2", "4x Scope",'350' },

	{ "COMPONENT_AT_SCOPE_MAX", "Advanced Scope",'550' },
	{ "COMPONENT_AT_SCOPE_LARGE", "Scope Large",'250' },
	{ "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2", "Scope Large",'250' },
	{ "COMPONENT_AT_SCOPE_LARGE_MK2", "8x Scope",'600' },

	{ "COMPONENT_AT_SCOPE_NV", "Nightvision Scope",'350' },
	{ "COMPONENT_AT_SCOPE_THERMAL", "Thermal Scope",'450' },

	--{ "COMPONENT_KNUCKLE_VARMOD_PLAYER", "Default Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_LOVE", "Love Skin",'150' },
	{ "COMPONENT_KNUCKLE_VARMOD_DOLLAR", "Dollar Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_VAGOS", "Vagos Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_HATE", "Hate Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_DIAMOND", "Diamond Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_PIMP", "Pimp Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_KING", "King Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_BALLAS", "Ballas Skin",'150'  },
	{ "COMPONENT_KNUCKLE_VARMOD_BASE", "Base Skin",'150'  },
	{ "COMPONENT_SWITCHBLADE_VARMOD_VAR1", "Default Skin",'150'  },
	{ "COMPONENT_SWITCHBLADE_VARMOD_VAR2", "Variant 2 Skin",'150' },
	--{ "COMPONENT_SWITCHBLADE_VARMOD_BASE", "Base Skin" },

	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_IND_01", "American Camo" },

	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01", "American Camo",'150'  },

	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01", "American Camo",'150' },

	{ "COMPONENT_REVOLVER_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_IND_01", "American Camo",'150'  },

	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01", "American Camo",'150'  },

	{ "COMPONENT_PISTOL_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO", "Camo 1",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_02", "Camo 2",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_03", "Camo 3",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_04", "Camo 4",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_05", "Camo 5",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_06", "Camo 6",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_07", "Camo 7",'150' },
	{ "COMPONENT_COMBATMG_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_07", "Camo 7",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_08", "Camo 8",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_09", "Camo 9",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_10", "Camo 10",'150'  },
	{ "COMPONENT_PISTOL_MK2_CAMO_IND_01", "American Camo",'150'  },
	{ "COMPONENT_SMG_MK2_CAMO_IND_01", "American Camo",'150'  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01", "American Camo",'150'  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01", "American Camo",'150'  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_IND_01", "American Camo",'150'  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01", "American Camo",'150'  },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01", "American Camo",'150'  },
}
local globalTintTable = {
	mk1 = {
		{ 1, "Green Tint", '150' },
		{ 2, "Gold Tint", '150' },
		{ 3, "Pink Tint", '150' },
		{ 4, "Army Tint", '150' },
		{ 5, "LSPD Tint", '150' },
		{ 6, "Orange Tint", '150' },
		{ 7, "Platinum Tint", '150' },
	},
	mk2 = {
		{ 1, "Classic Gray Tint", '150' },
		{ 2, "Classic TwoTone Tint", '150' },
		{ 3, "Classic White Tint", '150' },
		{ 4, "Classic Beige Tint", '150' },
		{ 5, "Classic Green Tint", '150' },
		{ 6, "Classic Blue Tint", '150' },
		{ 7, "Classic Earth Tint", '150' },
		{ 8, "Classic Brown And Black Tint", '150' },
		{ 9, "Red Contrast Tint", '150' },
		{ 10, "Blue Contrast Tint", '150' },
		{ 11, "Yellow Contrast Tint", '150' },
		{ 12, "Orange Contrast Tint", '150' },
		{ 13, "Bold Pink Tint", '150' },
		{ 14, "Bold Purple And Yellow Tint", '150' },
		{ 15, "Bold Orange Tint", '150' },
		{ 16, "Bold Green And Purple Tint", '150' },
		{ 17, "Bold Red Features Tint", '150' },
		{ 18, "Bold Green Features Tint", '150' },
		{ 19, "Bold Cyan Features Tint", '150' },
		{ 20, "Bold Yellow Features Tint", '150' },
		{ 21, "Bold Red And White Tint", '150' },
		{ 22, "Bold Blue And White Tint", '150' },
		{ 23, "Metallic Gold Tint", '150' },
		{ 24, "Metallic Platinum Tint", '150' },
		{ 25, "Metallic Gray And Lilac Tint", '150' },
		{ 26, "Metallic Purple And Lime Tint", '150' },
		{ 27, "Metallic Red Tint", '150' },
		{ 28, "Metallic Green Tint", '150' },
		{ 29, "Metallic Blue Tint", '150' },
		{ 30, "Metallic White And Aqua Tint", '150' },
		{ 31, "Metallic Red And Yellow", '150' },
	}
}
for ci,wepTable in pairs(globalWeaponTable) do
    local className = wepTable.name
    xnWeapons.weaponClasses[ci] = {
        name = className,
        weapons = {},
    }
    local classWepTable = xnWeapons.weaponClasses[ci].weapons
	for wi,weaponObject in ipairs(wepTable) do
		if weaponObject[4] then
			classWepTable[wi] = weaponObject[3]
			classWepTable[wi].name = weaponObject[2]
			classWepTable[wi].model = weaponObject[1]
			classWepTable[wi].price= weaponObject[4]
			classWepTable[wi].attachments = {}
		else
			classWepTable[wi] = {
				name = weaponObject[2],
				model = weaponObject[1],
				price = weaponObject[3],
				attachments = {},
			}
		end
        local wep = classWepTable[wi]
        for _,attachmentObject in ipairs(globalAttachmentTable) do
            if DoesWeaponTakeWeaponComponent(weaponObject[1], attachmentObject[1]) then
                wep.attachments[#wep.attachments+1] = {
                    name = attachmentObject[2],
                    model = attachmentObject[1],
					price = attachmentObject[3]
                }
            end
        end
		wep.clipSize = wep.clipSize or GetWeaponClipSize(weaponObject[1])
		wep.isMK2 = wep.isMK2 or (string.find(weaponObject[1], "_MK2") ~= nil)
    end
end
-- We do this once so that we don't run like 500 tests a tick on weapons and all the information is easily available to the menu

for intID, interior in pairs(xnWeapons.interiorIDs) do
	local additionalOffset = vec(0,0,0)	
	if type(interior) == "table" then
		additionalOffset = interior.additionalOffset or additionalOffset
	end
	
	local locationCoords = GetOffsetFromInteriorInWorldCoords(intID, (1.0),4.7,1.0) + additionalOffset
end

-- Main logic/magic loop
Citizen.CreateThread(function()
    local radius = 1.0  
    local waitForPlayerToLeave = false

	while true do Citizen.Wait(1)
		if GetInteriorFromEntity(GetPlayerPed(-1)) ~= 0 and xnWeapons.interiorIDs[GetInteriorFromEntity(GetPlayerPed(-1))] then
			local interiorID = GetInteriorFromEntity(GetPlayerPed(-1))
			local additionalOffset = vec(0,0,0)
			if type(xnWeapons.interiorIDs[interiorID]) == "table" then
				additionalOffset = xnWeapons.interiorIDs[interiorID].additionalOffset or additionalOffset
			end

            for i = 1,3 do
                if not IsAmmunationOpen() then
                    if (Vdist2(GetOffsetFromInteriorInWorldCoords(interiorID, (2.0-i),6.0,1.0) + additionalOffset, GetEntityCoords(PlayerPedId()))^2 <= radius^2) then
                        if not waitForPlayerToLeave then
                            BeginTextCommandDisplayHelp("GS_BROWSE_W")
                                AddTextComponentSubstringPlayerName("~INPUT_CONTEXT~")
                            EndTextCommandDisplayHelp(0, 0, true, -1)
                            if IsControlJustReleased(0, 51) then
								SetPlayerControl(PlayerId(), false)

								local additionalCameraOffset = vec(0,0,0)
								local additionalCameraPoint = vec(0,0,0)
								if type(xnWeapons.interiorIDs[interiorID]) == "table" then
									additionalCameraOffset = xnWeapons.interiorIDs[interiorID].additionalCameraOffset or additionalCameraOffset
									additionalCameraPoint = xnWeapons.interiorIDs[interiorID].additionalCameraPoint or additionalCameraPoint
								end
								
								xnWeapons.currentMenuCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA")
								local cam = xnWeapons.currentMenuCamera
								SetCamCoord(cam, GetOffsetFromInteriorInWorldCoords(interiorID, 3.25,6.5,2.0) + additionalCameraOffset)
								PointCamAtCoord(cam, GetOffsetFromInteriorInWorldCoords(interiorID, 5.0,6.5,2.0) + additionalCameraOffset + additionalCameraPoint)

								SetCamActive(cam, true)
								RenderScriptCams(true, 1, 600, 300, 0)

								Citizen.Wait(600)

								JayMenu.OpenMenu("xnweapons")

								waitForPlayerToLeave = true
                            end
                        end
                    else
                        if waitForPlayerToLeave then waitForPlayerToLeave = false end
					end
				end
			end
			additionalOffset = nil
			interiorID = nil
		end
    end
end)

local function IsWeaponMK2(weaponModel)
    return string.find(weaponModel, "_MK2")
end
local function DoesPlayerOwnWeapon(weaponModel)
    return HasPedGotWeapon(GetPlayerPed(-1), weaponModel, 0)
end

local function DoesPlayerWeaponHaveComponent(weaponModel, componentModel)
    return (DoesPlayerOwnWeapon(weaponModel) and HasPedGotWeaponComponent(GetPlayerPed(-1), weaponModel, componentModel) or false)
end

local function IsPlayerWeaponTintActive(weaponModel, tint)
	return (tint == GetPedWeaponTintIndex(GetPlayerPed(-1), weaponModel))
end

Citizen.CreateThread(function()
	function CreateFakeWeaponObject(weapon, keepOldWeapon)
		if weapon.noPreview then
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			xnWeapons.fakeWeaponObject = false
			return false 
		end

		local weaponWorldModel = GetWeapontypeModel(weapon.model)
		RequestModel(weaponWorldModel)
		while not HasModelLoaded(weaponWorldModel) do Citizen.Wait(0) end
		
		local interiorID = GetInteriorFromEntity(GetPlayerPed(-1))
		local rotationOffset = 0.0
		local additionalOffset = vec(0,0,0)
		local additionalWeaponOffset = vec(0,0,0)
		if type(xnWeapons.interiorIDs[interiorID]) == "table" then
			rotationOffset = xnWeapons.interiorIDs[interiorID].weaponRotationOffset or 0.0
			additionalOffset = xnWeapons.interiorIDs[interiorID].additionalOffset or additionalOffset
			additionalWeaponOffset = xnWeapons.interiorIDs[interiorID].additionalWeaponOffset or additionalWeaponOffset
		end
		local extraAdditionalWeaponOffset = weapon.offset or vec(0,0,0)

		local fakeWeaponCoords = (GetOffsetFromInteriorInWorldCoords(interiorID, 4.0,6.25,2.0) + additionalOffset) + additionalWeaponOffset + extraAdditionalWeaponOffset
		local fakeWeapon = CreateWeaponObject(weapon.model, weapon.clipSize*3, fakeWeaponCoords, true, 0.0)
		SetEntityAlpha(fakeWeapon, 0)
		SetEntityHeading(fakeWeapon, (GetCamRot(GetRenderingCam(), 1).z - 180)+rotationOffset)
		SetEntityCoordsNoOffset(fakeWeapon, fakeWeaponCoords)

		for i,attach in ipairs(weapon.attachments) do
			if DoesPlayerWeaponHaveComponent(weapon.model, attach.model) then
				GiveWeaponComponentToWeaponObject(fakeWeapon, attach.model)
			end
		end
		if DoesPlayerOwnWeapon(weapon.model) then SetWeaponObjectTintIndex(fakeWeapon, GetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model)) end

		if not keepOldWeapon then
			SetEntityAlpha(fakeWeapon, 255)
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			xnWeapons.fakeWeaponObject = fakeWeapon
		end

		return fakeWeapon
	end
end)

local currentTempWeapon = false
local tempWeaponLocked = false
local function SetTempWeapon(weapon)		
	if (not currentTempWeapon and weapon) or currentTempWeapon ~= weapon.model then
		currentTempWeapon = weapon
		if weapon == false then
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
		else
			if not tempWeaponLocked then
				tempWeaponLocked = true
				Citizen.CreateThread(function()
					CreateFakeWeaponObject(weapon)
					currentTempWeapon = weapon.model
					tempWeaponLocked = false
				end)
			end
		end
	end
end

local currentTempWeaponConfig = {
	component = false,
	tint = false,
}
local function SetTempWeaponConfig(weapon, component, tint)
	Citizen.CreateThread(function()
		if currentTempWeaponConfig.component ~= component or currentTempWeaponConfig.tint ~= tint then
			currentTempWeaponConfig = {
				component = component,
				tint = tint,
			}
			local fakeWeapon = CreateFakeWeaponObject(weapon, true)
			Citizen.Wait(30)
			if currentTempWeaponConfig.component then
				local attachWorldModel = GetWeaponComponentTypeModel(currentTempWeaponConfig.component)
				RequestModel(attachWorldModel)
				while not HasModelLoaded(attachWorldModel) do Citizen.Wait(0) end
				GiveWeaponComponentToWeaponObject(fakeWeapon, currentTempWeaponConfig.component)
			end
			if currentTempWeaponConfig.tint then
				SetWeaponObjectTintIndex(fakeWeapon, currentTempWeaponConfig.tint)
			else
				SetWeaponObjectTintIndex(fakeWeapon, GetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model))
			end
			
			-- Wait until we have assigned all the attachments and shit before we actually override the current weapon preview
			SetEntityAlpha(fakeWeapon, 255)
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			xnWeapons.fakeWeaponObject = fakeWeapon
		end
	end)
end

local function GiveWeapon(weaponhash, weaponammo)
    GiveWeaponToPed(GetPlayerPed(-1), weaponhash, weaponammo, false, true)
	SetPedAmmoByType(GetPlayerPed(-1), GetPedAmmoTypeFromWeapon_2(GetPlayerPed(-1), weaponhash), weaponammo)
end

local function GiveAmmo(weaponHash, ammo)
    AddAmmoToPed(GetPlayerPed(-1), weaponHash, ammo)
end

local function GiveMaxAmmo(weaponHash)
	local gotMaxAmmo, maxAmmo = GetMaxAmmo(GetPlayerPed(-1), weaponHash)
	if not gotMaxAmmo then maxAmmo = 99999 end
	SetAmmoInClip(GetPlayerPed(-1), weaponHash, GetWeaponClipSize(weaponHash))
    AddAmmoToPed(GetPlayerPed(-1), weaponHash, maxAmmo) 
end

local function RemoveWeapon(weaponhash)
    RemoveWeaponFromPed(GetPlayerPed(-1), weaponhash)
end

local function GiveComponent(weaponname, componentname, weapon)
	GiveWeaponComponentToPed(GetPlayerPed(-1), weaponname, componentname)
	CreateFakeWeaponObject(weapon)
end

local function RemoveComponent(weaponname, componentname, weapon)
	RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponname, componentname)
	CreateFakeWeaponObject(weapon)
end

local function SetPlayerWeaponTint(weaponname, tint, weapon)
	SetPedWeaponTintIndex(GetPlayerPed(-1), weaponname, tint)
	CreateFakeWeaponObject(weapon)
end

-- Weapon Saving
local weaponsCanSave = false -- prevent weapons from saving before they are loaded
Citizen.CreateThread(function()
	while GetIsLoadingScreenActive() and not PlayerPedId() do Citizen.Wait(0) end

	if GetConvar("xnw_enableWeaponSaving", true) then
		local loadedWeapons = json.decode(GetResourceKvpString("xnAmmunation:weapons") or "[]")
		for i,weapon in ipairs(loadedWeapons) do
			GiveWeaponToPed(GetPlayerPed(-1), weapon.model, 0, false, true)
			for i,attach in ipairs(weapon.attachments) do
				GiveWeaponComponentToPed(GetPlayerPed(-1), weapon.model, attach.model)
			end
			SetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model, weapon.tint)
			GiveAmmo(weapon.model, weapon.ammo)
		end
		SetPedCurrentWeaponVisible(PlayerPedId(), false, true)
		weaponsCanSave = true
	end
end)
local function SaveWeapons()
	if GetConvar("xnw_enableWeaponSaving", true) then
		local currentWeapons = {}

		for i,class in ipairs(xnWeapons.weaponClasses) do
			for i,weapon in ipairs(class.weapons) do
				if DoesPlayerOwnWeapon(weapon.model) then -- Construct weapons for saving
					local savedweapon = {
						model = weapon.model,
						tint = GetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model),
						ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon.model),
						attachments = {},
					}
					for i,attach in ipairs(weapon.attachments) do
						if DoesPlayerWeaponHaveComponent(weapon.model, attach.model) then
							savedweapon.attachments[#savedweapon.attachments+1] = attach
						end
					end
					currentWeapons[#currentWeapons+1] = savedweapon
				end
			end
		end
		SetResourceKvp("xnAmmunation:weapons", json.encode(currentWeapons))
	end
end
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		if weaponsCanSave then
			SaveWeapons()
		end
	end
end)

local function ReleaseWeaponModels()
	for ci,wepTable in pairs(globalWeaponTable) do
		for wi,weaponObject in ipairs(wepTable) do
			if weaponObject[1] and HasModelLoaded(GetWeapontypeModel(weaponObject[1])) then
				SetModelAsNoLongerNeeded(GetWeapontypeModel(weaponObject[1]))
				--print("released "..GetWeapontypeModel(weaponObject[1]))
			end
		end
	end
end


Citizen.CreateThread(function()
    JayMenu.CreateMenu("xnweapons", "Ammunation", function()
		SetPlayerControl(PlayerId(), true)
		SetCamActive(cam, false)
		RenderScriptCams(false, 1, 600, 300, 300)
		if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
		SetPedDropsWeaponsWhenDead(GetPlayerPed(-1), false)
		SaveWeapons() -- Once they exit the store, save their inventory
		ReleaseWeaponModels()
        return true
    end)
	JayMenu.SetSubTitle('xnweapons', "Weapons")

	JayMenu.CreateSubMenu("xnweapons_removeall_confirm","xnweapons","Are you sure?")

    for i,class in ipairs(xnWeapons.weaponClasses) do -- Create all menus for all weapons programatically
		JayMenu.CreateSubMenu("xnw_"..class.name, "xnweapons", class.name, function() 
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			return true
		end)

        for i,weapon in ipairs(class.weapons) do
			JayMenu.CreateSubMenu("xnw_"..class.name.."_"..weapon.model, "xnw_"..class.name, weapon.name, function() 
				SetTempWeaponConfig(weapon, false, false)
				return true
			end)
        end
	end
	
	while true do Citizen.Wait(0)
		if IsAmmunationOpen() then
			if JayMenu.IsMenuOpened('xnweapons') then
				for i,class in ipairs(xnWeapons.weaponClasses) do
					JayMenu.MenuButton(class.name, "xnw_"..class.name)
				end
				--if JayMenu.Button("Max All Ammo Types") then
					--for i,class in ipairs(xnWeapons.weaponClasses) do
						--for i,weapon in ipairs(class.weapons) do
							--if DoesPlayerOwnWeapon(weapon.model) then
							--	GiveMaxAmmo(weapon.model)
							--end
						--end
					--end
				--end
				--if JayMenu.Button("Get All Weapons") then
					--for i,class in ipairs(xnWeapons.weaponClasses) do
						--for i,weapon in ipairs(class.weapons) do
							--if not DoesPlayerOwnWeapon(weapon.model) then
								--GiveWeapon(weapon.model, 0)
								--GiveMaxAmmo(weapon.model)
							--end
						--end
					--end
				--end
				JayMenu.MenuButton("~r~Remove All Weapons", "xnweapons_removeall_confirm")
				JayMenu.Display()
			elseif JayMenu.IsMenuOpened('xnweapons_removeall_confirm') then
				if JayMenu.Button("No") then JayMenu.SwitchMenu("xnweapons")
				elseif JayMenu.Button("~r~Yes") then
					for i,class in ipairs(xnWeapons.weaponClasses) do
						for i,weapon in ipairs(class.weapons) do
							if DoesPlayerOwnWeapon(weapon.model) then
								RemoveWeapon(weapon.model)
							end
						end
					end
					SaveWeapons()
					JayMenu.SwitchMenu("xnweapons")
				end
				JayMenu.Display()
			end

			for i,class in ipairs(xnWeapons.weaponClasses) do
				if JayMenu.IsMenuOpened("xnw_"..class.name) then
					for i,weapon in ipairs(class.weapons) do
						if DoesPlayerOwnWeapon(weapon.model) then -- If they have the weapon take them to the customisation menu, else let them buy it...
							local clicked, hovered = JayMenu.SpriteMenuButton(weapon.name, "commonmenu", "shop_gunclub_icon_a", "shop_gunclub_icon_b", "xnw_"..class.name.."_"..weapon.model)
							if clicked then
								SetCurrentPedWeapon(GetPlayerPed(-1), weapon.model, true)
								CreateFakeWeaponObject(weapon)
							elseif hovered then
								SetTempWeapon(weapon)
							end
						else
							local clicked, hovered = JayMenu.Button(weapon.name, weapon.price)
							if clicked then
							ESX.TriggerServerCallback('xnweapons:getPlayerMoney',function(PlayerMoney) 
							local PlayerMoneyInt = tonumber(PlayerMoney)
							local weppriceInt = tonumber(weapon.price)
							if PlayerMoneyInt >= weppriceInt then
							TriggerServerEvent('xnweapons:buyItem', weapon.name, weapon.price)
								GiveWeapon(weapon.model, weapon.clipSize*3)
								SetCurrentPedWeapon(GetPlayerPed(-1), weapon.model, true)
								CreateFakeWeaponObject(weapon)
								JayMenu.SwitchMenu("xnw_"..class.name.."_"..weapon.model)
								else 
								ESX.ShowNotification('Not Enough Money', false, false, 'r')
								end
								end)
								
							elseif hovered then
								SetTempWeapon(weapon)
							end
						end
					end
			
					JayMenu.Display()
				end
				for i,weapon in ipairs(class.weapons) do
					if JayMenu.IsMenuOpened("xnw_"..class.name.."_"..weapon.model) then
						if JayMenu.Button("~r~Remove Weapon") then
							RemoveWeapon(weapon.model)
							JayMenu.SwitchMenu("xnw_"..class.name)
						end
						if not weapon.noAmmo then
							if JayMenu.Button(weapon.clipSize.."x Rounds", weapon.clipSize * 2) then
							ESX.TriggerServerCallback('xnweapons:getPlayerMoney',function(PlayerMoney) 
							local PlayerMoneyInt = tonumber(PlayerMoney)
							local totalRoundsPrice = weapon.clipSize * 2	
							local roundsInt = tonumber(totalRoundsPrice)
							if PlayerMoneyInt >= roundsInt then
							TriggerServerEvent('xnweapons:buyItem', 'Ammo', roundsInt)
								GiveAmmo(weapon.model, weapon.clipSize)
								else 
								ESX.ShowNotification('Not Enough Money', false, false, 'r')
								end
								end)
							end
							if JayMenu.Button("Max Ammo", weapon.clipSize *9999 ) then
							local MaxAmmoInt = tonumber(weapon.clipSize *9999)
							ESX.TriggerServerCallback('xnweapons:getPlayerMoney',function(PlayerMoney) 
							local PlayerMoneyInt = tonumber(PlayerMoney)
							if PlayerMoneyInt >= 19998 then
							TriggerServerEvent('xnweapons:buyItem', 'Max Ammo ', '19998')
								GiveMaxAmmo(weapon.model)
								else 
								ESX.ShowNotification('Not Enough Money', false, false, 'r')
								end
								end)
							
							
								
							end
						end
						for i,attachment in ipairs(weapon.attachments) do			
							if DoesPlayerWeaponHaveComponent(weapon.model, attachment.model) then -- If equipped show the gun icon, else show a tick because they "own" the attachment already
								local clicked, hovered = JayMenu.SpriteButton(attachment.name, "commonmenu", "shop_gunclub_icon_a", "shop_gunclub_icon_b")
								if clicked then
									RemoveComponent(weapon.model, attachment.model, weapon)
								elseif hovered then
									SetTempWeaponConfig(weapon, false, false)
								end
							else
								--local clicked, hovered = JayMenu.SpriteButton(attachment.name, "commonmenu", "shop_tick_icon")
								local clicked, hovered = JayMenu.Button(attachment.name, attachment.price)
								if clicked then
								ESX.TriggerServerCallback('xnweapons:getPlayerMoney',function(PlayerMoney)
								local PlayerMoneyInt = tonumber(PlayerMoney)
								local AttachmentPriceInt = tonumber(attachment.price)
								if PlayerMoneyInt >= AttachmentPriceInt then
								TriggerServerEvent('xnweapons:buyItem', attachment.name, attachment.price)
									GiveComponent(weapon.model, attachment.model, weapon)
									else
									ESX.ShowNotification('Not Enough Money', false, false, '~r~')
									end
									end)
								elseif hovered then
									SetTempWeaponConfig(weapon, attachment.model, false)
								end
							end
						end
						if not weapon.noTint then
							for i,tint in ipairs((weapon.isMK2 and globalTintTable.mk2 or globalTintTable.mk1)) do
								if IsPlayerWeaponTintActive(weapon.model, tint[1]) then -- If equipped show the gun icon, else show a tick because they "own" the attachment already
									local clicked, hovered = JayMenu.SpriteButton(tint[2], "commonmenu", "shop_gunclub_icon_a", "shop_gunclub_icon_b")
									if clicked then
										SetPlayerWeaponTint(weapon.model, 0, weapon)
									elseif hovered then
										SetTempWeaponConfig(weapon, false, tint[1])
									end
								else
									--local clicked, hovered = JayMenu.SpriteButton(tint[2], "commonmenu", "shop_tick_icon")
									local clicked, hovered = JayMenu.Button(tint[2], tint[3])
									if clicked then
									ESX.TriggerServerCallback('xnweapons:getPlayerMoney',function(PlayerMoney)
								local PlayerMoneyInt = tonumber(PlayerMoney)
								local TintPriceInt = tonumber(tint[3])
								if PlayerMoneyInt >= TintPriceInt then
								TriggerServerEvent('xnweapons:buyItem', tint[2], TintPriceInt)
										SetPlayerWeaponTint(weapon.model, tint[1], weapon)
										else
										ESX.ShowNotification('Not Enough Money', false, false, '~r~')
									end
									end)
									elseif hovered then
										SetTempWeaponConfig(weapon, false, tint[1])
									end
								end
							end
						end
						JayMenu.Display()
						DisplayAmmoThisFrame(true)
					end
				end
			end

			if xnWeapons.closeMenuNextFrame then
				xnWeapons.closeMenuNextFrame = false
				JayMenu.CloseMenu()
			end
		end
    end
end)

SetPlayerControl(PlayerId(), true)
RenderScriptCams(false, 0, 0, 0, 0)