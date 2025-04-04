/*
* Zombie Outbreak Roleplay
* (C) 2025 Zombie Outbreak Development Contributors
* GNU General Public License v3.0
*/
@cmd() ahelp(playerid, params[], help)
{
    switch(player[playerid][admin])
    {
        case 0: SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");
        case 1: 
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/a /asay /slap /akill /kick /mark /gotomark /goto /gethere");
        }
        case 2:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/a /asay /slap /akill /kick /mark /gotomark /goto /gethere");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/aban");
        }
        case 3:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/a /asay /slap /akill /kick /mark /gotomark /goto /gethere");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/aban");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/ipban");
        }
        case 4:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/a /asay /slap /akill /kick /mark /gotomark /goto /gethere");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/aban");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/ipban");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/rconbanip /unbanip /dsetpw");
        }
        case 5: 
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/a /asay /slap /akill /kick /mark /gotomark /goto /gethere");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/aban");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/ipban");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/rconbanip /unbanip /dsetpw");
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "/fly /createinterior /icis /setintvirworld /setinteriortype /setinteriorprice /showinteriors /cancelinterior");
        }
    }
    return 1;
}

/*
* Moderator
* Level: 1
*/
@cmd() a(playerid, params[], help)
{
    if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(isnull(params))
		return SendClientMessage(playerid, COLOR_RED, "USAGE: /a [text]");

	SendAdminMessage(playerid, COLOR_PURPLE, params);
    return 1;
}

@cmd() asay(playerid, params[], help)
{
    if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_RED, "USAGE: /asay [text]");

	SendClientMessageToAll(COLOR_CYAN, "Admin %s: %s", player[playerid][Name], params);
    return 1;
}

@cmd() slap(playerid, params[], help)
{
    new id, reason[76], Float:pPos[3];

    if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "ds[76]", id, reason))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /slap [playerid] [reason]");

    if(!IsPlayerConnected(id))
		return SendClientMessage(playerid, COLOR_RED, "Invalid ID.");

    GetPlayerPos(id, pPos[0], pPos[1], pPos[2]);
	SetPlayerPos(id, pPos[0], pPos[1], pPos[2] + 10);
	PlayerPlaySound(id, 1130, 0.0, 0.0, 0.0);
	SendClientMessageToAll(COLOR_ADMINMSG, "Administrator %s has slapped %s [Reason: %s]", player[playerid][Name], player[id][Name], reason);
    return 1;
}

@cmd() akill(playerid, params[], help)
{
    new id, reason[76];

	if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	if(sscanf(params,"ds[76]",id, reason))
		return SendClientMessage(playerid,COLOR_YELLOW,"USAGE: /akill [playerid] [reason]");

	if(!IsPlayerConnected(id))
		return SendClientMessage(playerid,COLOR_RED,"Invalid player ID.");

	SetPlayerHealth(playerid, 0.0);
	SendClientMessageToAll(COLOR_ADMINMSG, "Administrator %s has killed %s [Reason: %s]", player[playerid][Name], player[id][Name], reason);
    return 1;
}

@cmd() kick(playerid, params[], help)
{
    new id, reason[76], string[128];

	if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	if(sscanf(params, "ds[76]", id, reason))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /kick [playerid] [reason]");

    if(!IsPlayerConnected(id))
		return SendClientMessage(playerid, COLOR_RED, "Invalid ID.");

    SendClientMessageToAll(COLOR_ADMINMSG, "Administrator %s has kicked %s [Reason: %s]", player[playerid][Name], player[id][Name], reason);
    format(string, sizeof(string), "Administrator %s has kicked you! [Reason: %s]", player[playerid][Name], reason);
    KickWithMessage(id, COLOR_ADMINMSG, string);
	return 1;
}

@cmd() mark(playerid, params[], help)
{
	if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	GetPlayerPos(playerid, player[playerid][adminPos][0], player[playerid][adminPos][1], player[playerid][adminPos][2]);
	GetPlayerFacingAngle(playerid, player[playerid][adminPos][3]);

	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	SendClientMessage(playerid, COLOR_ADMINMSG, "Saved current location.");
	return 1;
}

@cmd() gotomark(playerid, params[], help)
{
	if(player[playerid][admin] < 1)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	SetPlayerPos(playerid, player[playerid][adminPos][0], player[playerid][adminPos][1], player[playerid][adminPos][2]);
	SetPlayerFacingAngle(playerid, player[playerid][adminPos][3]);
	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	SendClientMessage(playerid, COLOR_ADMINMSG, "You teleported to your last saved location.");
    return 1;
}

@cmd() goto(playerid, params[], help)
{
    new targetId = strval(params);

    if(player[playerid][admin] < 1)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(!IsPlayerConnected(targetId))
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Invalid player ID given.");

    new Float:pPos[3], tmpInt, tmpVirWorld;
    GetPlayerPos(targetId, pPos[0], pPos[1], pPos[2]);
    tmpInt = GetPlayerInterior(targetId);
    tmpVirWorld = GetPlayerVirtualWorld(targetId);

    SetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    SetPlayerInterior(playerid, tmpInt);
    SetPlayerVirtualWorld(playerid, tmpVirWorld);

    SendClientMessage(targetId, COLOR_ADMINMSG, "%s has teleported to you!", player[playerid][Name]);
	SendClientMessage(playerid, COLOR_ADMINMSG, "You teleported to %s's location!", player[targetId][Name]);
    return 1;
}

@cmd() gethere(playerid, params[], help)
{
    new targetId = strval(params);

    if(player[playerid][admin] < 1)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(!IsPlayerConnected(targetId))
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Invalid player ID given.");

    new Float:pPos[3], tmpInt, tmpVirWorld;
    GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    tmpInt = GetPlayerInterior(playerid);
    tmpVirWorld = GetPlayerVirtualWorld(playerid);

    SetPlayerPos(targetId, pPos[0], pPos[1], pPos[2]);
    SetPlayerInterior(targetId, tmpInt);
    SetPlayerVirtualWorld(targetId, tmpVirWorld);

    SendClientMessage(targetId, COLOR_ADMINMSG, "%s has teleported you to them!", player[playerid][Name]);
	SendClientMessage(playerid, COLOR_ADMINMSG, "You teleported %s to your location!", player[targetId][Name]);
    return 1;
}

/*
* Junior Admin
* Level: 2
*/
@cmd() aban(playerid, params[], help) // account banning
{
    new id, reason[76];

	if(player[playerid][admin] < 2)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "ds[76]", id, reason))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /aban [playerid] [reason]");

    if(!IsPlayerConnected(id))
		return SendClientMessage(playerid, COLOR_RED, "Invalid ID.");

	DB_ExecuteQuery(database, "UPDATE accounts SET isbanned = '1' WHERE username = '%q'", player[id][Name]);
	SendClientMessageToAll(COLOR_ADMINMSG, "Administrator %s has banned %s [Reason: %s]", player[playerid][Name], player[id][Name], reason);
	KickWithMessage(id, COLOR_ADMINMSG, "Administrator %s has banned you! [Reason: %s] (Is this wrong? Go to "SERVER_WEBSITE")", player[playerid][Name], reason);
	return 1;
}

/*
* Admin
* Level: 3
*/
@cmd() ipban(playerid, params[], help) // ip banning
{
    new id, reason[76];

	if(player[playerid][admin] < 3)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "ds[76]", id, reason))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /ipban [playerid] [reason]");

    if(!IsPlayerConnected(id))
		return SendClientMessage(playerid, COLOR_RED, "Invalid ID.");

	SendClientMessageToAll(COLOR_ADMINMSG, "Administrator %s has banned %s [Reason: %s]", player[playerid][Name], player[id][Name], reason);
   	BanWithMessage(id, COLOR_ADMINMSG, "Administrator %s has banned you! [Reason: %s] (Is this wrong? Go to """SERVER_WEBSITE")", player[playerid][Name], reason);
	return 1;
}

/*
* Senior Admin
* Level: 4
*/
@cmd() rconbanip(playerid, params[], help)
{
    new tmpIP[16];

	if(player[playerid][admin] < 4)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	if(sscanf(params, "s[16]", tmpIP))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /rconbanip [ip]");

    SendRconCommand("banip %s", tmpIP);
    SendClientMessage(playerid, COLOR_ADMINMSG, "You banned the IP: %s and added it to the ban database!", tmpIP);
    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
    return 1;
}

@cmd() unbanip(playerid, params[], help)
{
    new tmpIP[16];

	if(player[playerid][admin] < 4)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	if(sscanf(params, "s[16]", tmpIP))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /unbanip [ip]");

    SendRconCommand("unbanip %s", tmpIP);
    SendRconCommand("reloadbans");
    SendClientMessage(playerid, COLOR_ADMINMSG, "You unbanned the IP: %s from the ban database!", tmpIP);
    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
    return 1;
}

@cmd() dsetpw(playerid, params[], help)
{
    new pw[128];

	if(player[playerid][admin] < 4)
		return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

	if(sscanf(params,"s[24]s[128]", params, pw))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /dsetpw [Username] [password].");

    bcrypt_hash(playerid, "OnUserPasswordChange", pw, BCRYPT_COST);
    SendClientMessage(playerid, COLOR_ADMINMSG, "You've set %s's password.", params);
    return 1;
}

/*
* Server Management
* Level: 5
*/
@cmd() fly(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(player[playerid][isflying])
	{
		player[playerid][isflying] = false;
		SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "* Fly mode offline.");
		TogglePlayerControllable(playerid, true);
        KillTimer(player[playerid][flyTimer]);
	}
	else
	{
		player[playerid][isflying] = true;
		SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "* Fly mode online.");
		TogglePlayerControllable(playerid, false);
        player[playerid][flyTimer] = SetTimerEx("FlyTimer", 100, true, "d", playerid);
	}
	return 1;
}

/*@cmd() setnpcname(playerid, params[], help)
{
    new npcid, newName[MAX_PLAYER_NAME];
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "is[24]", npcid, newName)) 
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Syntax error. Correct usage: /setnpcname [npcid] [new name]");

    if(strlen(newName) > MAX_PLAYER_NAME)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Entered name is too long.");

    WriteNewNpcName(npcid, newName);
	return 1;
}

@cmd() setnpcvirworld(playerid, params[], help)
{
    new npcid, newvirworld;
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "ii", npcid, newvirworld)) 
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Syntax error. Correct usage: /setnpcvirworld [npcid] [virtual world id]");

    if(newvirworld < 0 || newvirworld > 2147483646)
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You cannot set a negative virtual world ID. Valid IDs 0 - 2147483646");

    WriteNewNpcVirtualWorld(npcid, newvirworld);
	return 1;
}*/

/*
* Creating and editing interiors
*/
@cmd() createinterior(playerid, params[], help)
{
    new intname[64], DBResult:Result, newIntId;

    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "s[64]", intname)) 
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Syntax error. Correct usage: /createinterior [name]");

    if(GetPVarInt(playerid, "createintstep") >= 1)
    {
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You are already in the middle of creating an interior.");
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Either finish creating the one you are doing or use /cancelinterior to cancel current task.");
        return 1;
    }

    /*
    * Create the interior into the database
    */
    DB_ExecuteQuery(database, "INSERT INTO interiors (name) VALUES ('%q')", intname);

    /*
    * Now set the new ID into the global array and into a PVar for use in other commands
    */
    Result = DB_ExecuteQuery(database, "SELECT id FROM interiors WHERE name = '%q'", intname);

	if(DB_GetFieldCount(Result) > 0)
    {
        newIntId = DB_GetFieldIntByName(Result, "id");
        SetPVarInt(playerid, "currentInterior", newIntId);
    }
    DB_FreeResultSet(Result);

    /*
    * Now we are ready to continue
    */
    SetPVarInt(playerid, "createintstep", 1);
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Stand where the interior entrance is and use the command /icis");
    return 1;
}

@cmd() icis(playerid, params[], help) // icis = initiate create interior step
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    new Float:ppos[4];
    switch(GetPVarInt(playerid, "createintstep"))
    {
        case 1:
        {
            GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
            
            DB_ExecuteQuery(database, "UPDATE interiors SET penterx1 = '%f', pentery1 = '%f', penterz1 = '%f' WHERE id = '%d'",
                ppos[0], ppos[1], ppos[2], GetPVarInt(playerid, "currentInterior"));

            SetPVarInt(playerid, "createintstep", 2);
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Stand where the player will be teleported to inside the interior then use /icis");
        }
        case 2:
        {
            GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
            GetPlayerFacingAngle(playerid, ppos[3]);

            DB_ExecuteQuery(database, "UPDATE interiors SET penterx2 = '%f', pentery2 = '%f', penterz2 = '%f', pentera = '%f' WHERE id = '%d'",
                ppos[0], ppos[1], ppos[2], ppos[3], GetPVarInt(playerid, "currentInterior"));

            SetPVarInt(playerid, "createintstep", 3);
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Stand where the player will go to leave the interior then use /icis");
        }
        case 3:
        {
            GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);

            DB_ExecuteQuery(database, "UPDATE interiors SET pexitx1 = '%f', pexity1 = '%f', pexitz1 = '%f' WHERE id = '%d'",
                ppos[0], ppos[1], ppos[2], GetPVarInt(playerid, "currentInterior"));

            SetPVarInt(playerid, "createintstep", 4);
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Stand where the player will be teleported to outside the interior then use /icis");
        }
        case 4:
        {
            GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
            GetPlayerFacingAngle(playerid, ppos[3]);

            DB_ExecuteQuery(database, "UPDATE interiors SET pexitx2 = '%f', pexity2 = '%f', pexitz2 = '%f', pexita = '%f' WHERE id = '%d'",
                ppos[0], ppos[1], ppos[2], ppos[3], GetPVarInt(playerid, "currentInterior"));

            SetPVarInt(playerid, "createintstep", 5);
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Now set the interior's virtual world using /setintvirworld.");
        }
        default:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_ERROR, "ICIS used out of scope.");
            print("====ICIS ERROR====");
            print("Potentially used outside of scope?");
            printf("createintstep PVAR = %d", GetPVarInt(playerid, "createintstep"));
        }
    }
    return 1;
}

@cmd() setintvirworld(playerid, params[], help)
{
    new intvirworld;

    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "i", intvirworld)) 
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Syntax error. Correct usage: /setintvirworld [virtual world ID]");

    if(GetPVarInt(playerid, "createintstep") != 5)
    {
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You have not reached this stage in creating an interior or you are not creating one currently.");
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Either start a creation with /createinterior or use /icis at the relevant step.");
        return 1;
    }

    /*
    * Insert the interior virtual world
    */
    srvInterior[GetPVarInt(playerid, "currentInterior")][intVirWorld] = intvirworld;
    DB_ExecuteQuery(database, "UPDATE interiors SET virworld = '%d' WHERE id = '%d'", 
        srvInterior[GetPVarInt(playerid, "currentInterior")][intVirWorld], GetPVarInt(playerid, "currentInterior"));

    /*
    * Next step
    */
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Now set the default price to buy this interior using /setinteriortype [type]");
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Using an ID out of scope will create a purchasable player home by default.");
    SetPVarInt(playerid, "createintstep", 6);
    return 1;
}

@cmd() setinteriortype(playerid, params[], help)
{
    new cmdIntType;

    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "i", cmdIntType)) 
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Syntax error. Correct usage: /setinteriortype [type]");

    if(GetPVarInt(playerid, "createintstep") != 6)
    {
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You have not reached this stage in creating an interior or you are not creating one currently.");
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Either start a creation with /createinterior or use the relevant command for the current step in the process.");
        return 1;
    }

    switch(cmdIntType)
    {
        case INTERIOR_TYPE_PLAYERHOME:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Interior type set to player home.");
        }
        case INTERIOR_TYPE_FACTIONBASE:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Interior type set to faction base.");
        }
        case INTERIOR_TYPE_PUBLIC:
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Interior type set to public (non-purchasable, always unlocked).");
            
            // interior should be unlocked as it is a public interior
            DB_ExecuteQuery(database, "UPDATE interiors SET islocked = '0' WHERE id = '%d'", GetPVarInt(playerid, "currentInterior"));
        }
        default: 
        {
            SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Interior type out of scope, interior has been set to the default (INTERIOR_TYPE_PUBLIC)");
            cmdIntType = INTERIOR_TYPE_PUBLIC;

            // interior should be unlocked as it is a public interior
            DB_ExecuteQuery(database, "UPDATE interiors SET islocked = '0' WHERE id = '%d'", GetPVarInt(playerid, "currentInterior"));
        }
    }

    /*
    * Insert the interior type
    */
    srvInterior[GetPVarInt(playerid, "currentInterior")][intType] = cmdIntType;
    DB_ExecuteQuery(database, "UPDATE interiors SET interiortype = '%d' WHERE id = '%d'", 
        srvInterior[GetPVarInt(playerid, "currentInterior")][intType], GetPVarInt(playerid, "currentInterior"));


    /*
    * Next step
    */
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Now set the default price to buy this interior using /setinteriorprice [amount]");
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "If the interior is a public interior for scavenging etc. then please set the price to 0.");
    SetPVarInt(playerid, "createintstep", 7);
    return 1;
}

@cmd() setinteriorprice(playerid, params[], help)
{
    new cmdIntPrice;

    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(sscanf(params, "i", cmdIntPrice)) 
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Syntax error. Correct usage: /setinteriorprice [amount]");

    if(GetPVarInt(playerid, "createintstep") != 7)
    {
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You have not reached this stage in creating an interior or you are not creating one currently.");
        SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Either start a creation with /createinterior or use the relevant command for the current step in the process.");
        return 1;
    }

    /*
    * Insert the interior price
    */
    srvInterior[GetPVarInt(playerid, "currentInterior")][intPrice] = cmdIntPrice;
    DB_ExecuteQuery(database, "UPDATE interiors SET purchaseprice = '%d' WHERE id = '%d'", 
        srvInterior[GetPVarInt(playerid, "currentInterior")][intPrice], GetPVarInt(playerid, "currentInterior"));

    /*
    * Give player confirmation of success
    */
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "Interior created successfully.");
    DeletePVar(playerid, "createintstep");

    /*
    * Update interior count
    */
    new DBResult:Result;
    Result = DB_ExecuteQuery(database, "SELECT COUNT(*) FROM interiors");
	serverInteriorCount = DB_GetFieldInt(Result);
	DB_FreeResultSet(Result);

    /*
    * Load the new interior data
    */
    LoadInteriorData(GetPVarInt(playerid, "currentInterior"));
    DeletePVar(playerid, "currentInterior");
    return 1;
}

@cmd() showinteriors(playerid, params[], help)
{
    new tmpIntName[64], DBResult:Result;

    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    for(new i = 0; i < MAX_SERVER_INTERIORS; i++)
    {
        Result = DB_ExecuteQuery(database, "SELECT name FROM interiors WHERE id = '%d'", i);

        if(DB_GetFieldCount(Result) > 0)
        {
            DB_GetFieldStringByName(Result, "name", tmpIntName, 64);
            AddDialogListitem(playerid, tmpIntName);
        }
        DB_FreeResultSet(Result);
    }

    ShowPlayerDialogPages(playerid, "ShowInteriorsDialog", DIALOG_STYLE_LIST, "Server Interiors", "Select", "Close", 15);
    return 1;
}

@cmd() cancelinterior(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    if(GetPVarInt(playerid, "createintstep") < 1)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You are not currently creating an interior.");

    /*
    * Send DELETE FROM command to database to remove current interior from the database (stops bugged interiors hopefully)
    */
    new DBResult:Result = DB_ExecuteQuery(database, "DELETE FROM interiors WHERE id = '%d'", GetPVarInt(playerid, "currentInterior"));
    DB_FreeResultSet(Result);

    /*
    * Cancel and confirm cancellation to player
    */
    SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_INFO, "You cancelled the create/edit interior task.");
    DeletePVar(playerid, "createintstep");
    DeletePVar(playerid, "currentInterior");
    return 1;
}

@cmd() resetvworld(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    SetPlayerVirtualWorld(playerid, 0);
    SendClientMessage(playerid, COLOR_ADMINISTRATOR, "You reset your Virtual world to 0.");
    return 1;
}

/*
* TEST COMMAND TO BE REMOVED ONCE IT'S EASIER TO SURVIVE
*/
@cmd() heal(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");
        
	SetPlayerHealth(playerid, player[playerid][maxHealth]);
	player[playerid][hunger] = 100;
	player[playerid][thirst] = 100;
    player[playerid][disease] = 100;
	
	UpdateHudElementForPlayer(playerid, HUD_HUNGER);
	UpdateHudElementForPlayer(playerid, HUD_THIRST);
	UpdateHudElementForPlayer(playerid, HUD_HEALTH);
    UpdateHudElementForPlayer(playerid, HUD_DISEASE);
	return 1;
}

@cmd() dam(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");
        
	SetPlayerHealth(playerid, player[playerid][maxHealth]);
	player[playerid][hunger] = 0;
	player[playerid][thirst] = 0;
	
	UpdateHudElementForPlayer(playerid, HUD_HUNGER);
	UpdateHudElementForPlayer(playerid, HUD_THIRST);
	UpdateHudElementForPlayer(playerid, HUD_HEALTH);
	return 1;
}

@cmd() tut(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");

    new string[1024];
    format(string, sizeof(string), "This is a test dialogue for the tutorial. It tests how long a string can be shown (should be up to 1024 characters), \
    as well as showing how it displays to the user. I can check if I need to create something new for the tutorial and information boxes.");
    ShowDialogueTextDraw(playerid, string);
    SetTimerEx("HideInfoBox", 10000, false, "d", playerid);
    return 1;
}

@cmd() dis(playerid, params[], help)
{
    if(player[playerid][admin] < 5)
        return SendPlayerServerMessage(playerid, COLOR_SYSTEM, PLR_SERVER_MSG_TYPE_DENIED, "You do not have a high enough admin rank to use this command.");
        
    player[playerid][disease] = 0;
    UpdateHudElementForPlayer(playerid, HUD_DISEASE);
    return 1;
}