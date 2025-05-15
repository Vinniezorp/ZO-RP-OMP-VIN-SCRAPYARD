/*
* Zombie Outbreak Roleplay
* (C) 2025 Zombie Outbreak Development Contributors
* GNU General Public License v3.0
*/

/*
* Gamemode defines
*/
#include "modules/defines.pwn"

/*
* The one library to rule them all
*/
#include <open.mp>

/*
* YSI Libraries
*/
#include <YSI_Visual\y_commands>
#include <YSI_Visual\y_dialog>

/*
* Other Libraries
*/
#include <samp_bcrypt>
#include <filemanager>
#include <streamer>
#include <sscanf2>
#include <weapon-config>
#include <ndialog-pages>
#include <eSelection>
#include <colandreas>

/*
* Variables
*/
#include "modules/variables.pwn"

/*
* Gamemode Function Declarations
* Also contains general functions
*/
#include "modules/functions.pwn"

/*
* Gamemode Modules
* For specific functions
*/
#include "modules/map.pwn"
#include "modules/sql.pwn"
#include "modules/timers.pwn"
#include "modules/textdraws.pwn"
#include "modules/dialogs.pwn"

/*
* Command Modules
*/
#include "modules/player_cmds.pwn"
#include "modules/admin_cmds.pwn"

/*
* Start gamemode
*/
main()
{
    SendRconCommand("name "SERVER_NAME);
    SendRconCommand("rcon.password "SERVER_RCON);
    SendRconCommand("game.mode "SERVER_VERSION);
    SendRconCommand("game.map "SERVER_MAP);
    SendRconCommand("website "SERVER_WEBSITE);
    SendRconCommand("password "SERVER_PASSWORD);

    printf(""SERVER_NAME" ("SERVER_VERSION"), has been loaded successfully.");
    print("Zombie Outbreak Roleplay by the Zombie Outbreak Roleplay Contributors");
}

public OnGameModeInit()
{
	/*
	* Connect to database file and create tables if they don't exist.
	*/
	SetupDatabase();

	/*
    * Gamemode Settings
    */
	ManualVehicleEngineAndLights();
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetVehiclePassengerDamage(true);
    SetVehicleUnoccupiedDamage(true);
    SetDisableSyncBugs(true);
    SetDamageFeed(false);

	/*
	* Get Interior count
	*/
	new DBResult:Result;
    Result = DB_ExecuteQuery(database, "SELECT COUNT(*) FROM interiors");
	serverInteriorCount = DB_GetFieldInt(Result);
	DB_FreeResultSet(Result);
    
    /*
    * Get scav area count
    */
    Result = DB_ExecuteQuery(database, "SELECT COUNT(*) FROM scavareas");
    scavAreaCount = DB_GetFieldInt(Result);
    DB_FreeResultSet(Result);

	/*
    * Parse MTA Maps
    * This loads all map objects, vehicles and NPCs, and Interior data
    */
    ParseMapFiles();

	for(new i = 0; i < MAX_SERVER_INTERIORS; i++)
    {
		LoadInteriorData(i);
	}

	/*
	* Load all the saved factions
	*/
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
		LoadFactionData(i);
	}

    /*
    * Load global 3D text labels
    */
    for(new i = 0; i < MAX_LOCKERS; i++)
    {
        CreateDynamic3DTextLabel("/locker", COLOR_GREEN, lockerLocation[i][0], lockerLocation[i][1], lockerLocation[i][2], 20.0, 
            .testlos = 1, .worldid = lockerVirWorld[i], .interiorid = lockerInterior[i]);
    }

    for(new i = 1; i < scavAreaCount; i++) // ids start from 1 due to database ID autoincrement starting at 1
    {
        LoadScavArea(i);
    }

	/*
	* Server Textdraws
	*/
	CreateServerTextdraws();

	/*
	* Set default weather on server start (random)
	*/
	SetWeather(random(22)); // between 0 - 22

    /*
    * Timers
    */
    SetTimer("PlayerChecks", 500, true);
	SetTimer("ServerTime", 1000, true);
	SetTimer("ServerWeather", 3600000, true);
	return 1;
}

public OnGameModeExit()
{
	DB_Close(database);
	return 1;
}

public OnPlayerConnect(playerid)
{
	// no NPCs here... for now
    if(IsPlayerNPC(playerid))
		return Kick(playerid);

	/*
	* Reset player variables
	*/
	static const empty_player[E_PLAYERS];
	player[playerid] = empty_player;
	for(new i = 0; i < MAX_ITEMS; i++)
	{
		playerInventory[playerid][i] = 0;
	}

	/*
	* Clear all dialog list entries
	*/
	ClearDialogListitems(playerid);

	/*
	* Remove objects for the map.
	*/
	RemoveBuildings(playerid);

	/*
	* Get the player's connected name and toggle their spectating status.
	*/
	SetPlayerColor(playerid, COLOR_GREY);
	GetPlayerName(playerid, player[playerid][Name]);
	GetPlayerIp(playerid, player[playerid][ip]);
    gpci(playerid, player[playerid][serial]);
	TogglePlayerSpectating(playerid, true);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	SetPlayerWeather(playerid, GetWeather()); // make sure player weather is synced upon connection

	/*
	* Create Needed Textdraws
	*/
	CreateDialogueTextdraw(playerid);
	CreatePlayerHud(playerid);

	/*
	* Setup login camera
	*/
	SetTimerEx("LoginCamera", 1500, false, "d", playerid);

	/*
	* Check account exists
	*/
	CheckPlayerAccountExists(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DestroyHudForPlayer(playerid);
	DestroyDialogueTextdraw(playerid);

	/*
	* Save character data if the player is spawned as one.
	*/
	if(player[playerid][isSpawned])
	{
		SavePlayerCharacter(playerid, player[playerid][chosenChar]);
	}
	SetPlayerName(playerid, player[playerid][Name]);

	// if the player was kicked before the time expires then kill the timer
	if (player[playerid][LoginTimer])
	{
		KillTimer(player[playerid][LoginTimer]);
		player[playerid][LoginTimer] = 0;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 1);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	/*
	* Kill timers and reset spawned variable as well as hide the HUD
	*/
	player[playerid][spawned] = 0;
	KillTimer(player[playerid][hungerTimer]);
	KillTimer(player[playerid][thirstTimer]);
	KillTimer(player[playerid][diseaseTimer]);
	KillTimer(player[playerid][fuelTimer]);
	KillTimer(player[playerid][fillVehicleTimer]);
	HideHudForPlayer(playerid);

	/*
	* Set the player to spectate mode and set the timer to respawn
	*/
	TogglePlayerSpectating(playerid, true);
	GameTextForPlayer(playerid, "...Respawning...", 3500, 3);
	SetTimerEx("RespawnAfterDeath", 3500, false, "d", playerid);
	return 1;
}

public OnPlayerDamageDone(playerid, Float:amount, issuerid, WEAPON:weapon, bodypart)
{
    UpdateHudElementForPlayer(playerid, HUD_HEALTH);
    return 1;
}

public OnPlayerText(playerid, text[])
{
	if(player[playerid][iszombie] == 1)
	{
		SendProxMessage(playerid, COLOR_RP_PURPLE, 30.0, PROXY_MSG_TYPE_OTHER, "snarls and groans");
	}
	else
	{
		SendProxMessage(playerid, COLOR_WHITE, 30.0, PROXY_MSG_TYPE_CHAT, text);
	}
	return 0;
}

public e_COMMAND_ERRORS:OnPlayerCommandReceived(playerid, cmdtext[], e_COMMAND_ERRORS:success)
{
    switch(success)
    {
        case COMMAND_UNDEFINED:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_ERROR, "Command does not exist!");
        	SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Use /commands to see a list of commands.");
        }
    }
    return COMMAND_OK;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new i = 0; i < MAX_SERVER_INTERIORS; i++)
    {
		if(player[playerid][createIntStep] >= 1) // if player is making an interior then don't call this script until they're done
            return 1;

		if(pickupid == interiorEnterPickup[i])
		{
			player[playerid][atProperty] = i; // used to determine which property someone is at (for purchasing etc)

			if(strcmp("Vacant", srvInterior[i][intOwner]) == 0)
			{
				if(srvInterior[i][intType] == INTERIOR_TYPE_PUBLIC)
				{
					// interior is unlocked so let them in
					SetPlayerWeather(playerid, 0);
					SetPlayerPos(playerid, srvInterior[i][intEnter][3], srvInterior[i][intEnter][4], srvInterior[i][intEnter][5]);
					SetPlayerFacingAngle(playerid, srvInterior[i][intEnter][6]);
					SetCameraBehindPlayer(playerid);
					SetPlayerInterior(playerid, srvInterior[i][intWorld]);
					SetPlayerVirtualWorld(playerid, srvInterior[i][intVirWorld]);
					GameTextForPlayer(playerid, "You entered %s", 5000, 3, srvInterior[i][intName]);
				}
				
				if(player[playerid][antiMessageSpam] != 1)
				{
					if(srvInterior[i][intType] != INTERIOR_TYPE_PUBLIC)
					{
						SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "To purchase this property please type /purchaseproperty.");
						player[playerid][antiMessageSpam] = 1;
						SetTimerEx("AntiMessageSpamTimer", 2500, false, "d", playerid);
					}
				}
			}
			else
			{
				if(srvInterior[i][intLocked] == 1)
				{
					if(player[playerid][antiMessageSpam] != 1)
					{
						SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You cannot enter this location as it has been locked.");
						player[playerid][antiMessageSpam] = 1;
						SetTimerEx("AntiMessageSpamTimer", 2500, false, "d", playerid);
					}

					// if the player is the owner of the property let them in anyway
					if(strcmp(player[playerid][chosenChar], srvInterior[i][intOwner]) == 0)
					{
						SetPlayerWeather(playerid, 0);
						SetPlayerPos(playerid, srvInterior[i][intEnter][3], srvInterior[i][intEnter][4], srvInterior[i][intEnter][5]);
						SetPlayerFacingAngle(playerid, srvInterior[i][intEnter][6]);
						SetCameraBehindPlayer(playerid);
						SetPlayerInterior(playerid, srvInterior[i][intWorld]);
						SetPlayerVirtualWorld(playerid, srvInterior[i][intVirWorld]);
						GameTextForPlayer(playerid, "You entered %s", 5000, 3, srvInterior[i][intName]);
					}
				}
				else
				{
					// interior is unlocked so let them in
					SetPlayerWeather(playerid, 0);
					SetPlayerPos(playerid, srvInterior[i][intEnter][3], srvInterior[i][intEnter][4], srvInterior[i][intEnter][5]);
					SetPlayerFacingAngle(playerid, srvInterior[i][intEnter][6]);
					SetCameraBehindPlayer(playerid);
					SetPlayerInterior(playerid, srvInterior[i][intWorld]);
					SetPlayerVirtualWorld(playerid, srvInterior[i][intVirWorld]);
					GameTextForPlayer(playerid, "You entered %s", 5000, 3, srvInterior[i][intName]);
				}
			}
		}
		else if(pickupid == interiorExitPickup[i])
		{
			// should always be allowed to leave regardless of interior status
			SetPlayerWeather(playerid, GetWeather());
			SetPlayerPos(playerid, srvInterior[i][intExit][3], srvInterior[i][intExit][4], srvInterior[i][intExit][5]);
			SetPlayerFacingAngle(playerid, srvInterior[i][intExit][6]);
			SetCameraBehindPlayer(playerid);
			SetPlayerInterior(playerid, srvInterior[i][intExitWorld]);
			SetPlayerVirtualWorld(playerid, srvInterior[i][intExitVirWorld]);
			GameTextForPlayer(playerid, "You exited %s", 5000, 3, srvInterior[i][intName]);
		}
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	/*
	* Remove ammo from inventory when a weapon is shot
	*/
    switch(weaponid)
	{
		case WEAPON_COLT45, WEAPON_SILENCED, WEAPON_DEAGLE, WEAPON_UZI, WEAPON_TEC9:
		{
			new nineMMAmmoId = ReturnItemIdByName("9mm Round");
			playerInventory[playerid][nineMMAmmoId] = playerInventory[playerid][nineMMAmmoId] - 1;

			if(playerInventory[playerid][nineMMAmmoId] <= 0)
			{
				playerInventory[playerid][nineMMAmmoId] = 0;
			}
		}
		case WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA:
		{
			new shotgunAmmo = ReturnItemIdByName("12 Gauge Shell");
			playerInventory[playerid][shotgunAmmo] = playerInventory[playerid][shotgunAmmo] - 1;

			if(playerInventory[playerid][shotgunAmmo] <= 0)
			{
				playerInventory[playerid][shotgunAmmo] = 0;
			}
		}
	}
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new allowedWeapons[] = {WEAPON_COLT45, WEAPON_UZI, WEAPON_MP5, WEAPON_TEC9};
	if(newstate == PLAYER_STATE_DRIVER) 
	{
		SetPlayerArmedWeapon(playerid, WEAPON_FIST);
		player[playerid][lastInVehId] = GetPlayerVehicleID(playerid);
		if(serverVehicle[player[playerid][lastInVehId]][engine]) // vehicle engine is turned on so show HUD
		{
			// show the fuel hud and start the vehicle timer
			ShowHudForPlayer(playerid, HUD_VEHICLE);
			player[playerid][fuelTimer] = SetTimerEx("FuelTimer", 25000, true, "dd", playerid, player[playerid][lastInVehId]);
		}
	}
	else if(newstate == PLAYER_STATE_PASSENGER)
	{
		for(new i = 0; i < sizeof(allowedWeapons); i++) 
		{
			if(GetPlayerWeapon(playerid) != allowedWeapons[i])
			{
				SetPlayerArmedWeapon(playerid, WEAPON_FIST);
			}
		}
		player[playerid][lastInVehId] = GetPlayerVehicleID(playerid);
	}

	/*
	* Hide the fuel HUD when the driver exits the vehicle
	*/
	if(oldstate == PLAYER_STATE_DRIVER) 
	{
		SetPlayerArmedWeapon(playerid, WEAPON_FIST);
		HideHudElementForPlayer(playerid, HUD_VEHICLE);
		KillTimer(player[playerid][fuelTimer]);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsKeyJustDown(KEY_SPRINT, newkeys, oldkeys))
	{
	    StopLoopingAnim(playerid);
        TextDrawHideForPlayer(playerid, animhelper);
    }
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetupVehicleForSpawn(vehicleid);
	return 1;
}

public OnPlayerFinishedDownloading(playerid, virtualworld)
{
    return 1;
}
