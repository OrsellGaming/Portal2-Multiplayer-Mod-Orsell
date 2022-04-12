// █░█ █▀█ █▀█ █▄▀   █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
// █▀█ █▄█ █▄█ █░█   █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█

//////////////////////////////
// Runs when a player joins //
//////////////////////////////

function OnPlayerJoin(p, script_scope) {

    // GlobalSpawnClass Teleport
    if (GlobalSpawnClass.useautospawn == true) {
        TeleportToSpawnPoint(p, null)
    }

    //# Get player's index and store it #//
    PlayerID <- p.GetRootMoveParent()
    PlayerID <- PlayerID.entindex()

    //# Assign every new targetname to the player after blue and red are used #//
    if (PlayerID >= 3) {
        p.__KeyValueFromString("targetname", "player" + PlayerID)
    }

    //# Change player portal targetname #//
    local ent1 = null
    local ent2 = null
    local ent = null
    local portal1 = null
    local portal2 = null
    while (ent = Entities.FindByClassname(ent, "prop_portal")) {
        if (ent.GetName() == "") {
            if (ent1 == null) {
                ent1 = ent
            } else {
                ent2 = ent
            }
        }
    }

    try {
        if (ent1.entindex() > ent2.entindex()) {
            ent1.__KeyValueFromString("targetname", "player" + p.entindex() + "_portal" + "2")
            ent2.__KeyValueFromString("targetname", "player" + p.entindex() + "_portal" + "1")
            portal1 = ent2
            portal2 = ent1
        } else {
            ent1.__KeyValueFromString("targetname", "player" + p.entindex() + "_portal" + "1")
            ent2.__KeyValueFromString("targetname", "player" + p.entindex() + "_portal" + "2")
            portal1 = ent1
            portal2 = ent2
        }
        CreateEntityClass(portal1)
        CreateEntityClass(portal2)
        FindEntityClass(portal1).linkedprop <- null
        FindEntityClass(portal2).linkedprop <- null
    } catch (exception) {
        if (GetDeveloperLevel() == 1) {
            printl("(P2:MM): Failed to rename portals" + exception)
        }
    }

    //# Set viewmodel targetnames so we can tell them apart #//
    local ent = null
    while (ent=Entities.FindByClassname(ent, "predicted_viewmodel")) {
        EntFireByHandle(ent, "addoutput", "targetname viewmodel_player" + ent.GetRootMoveParent().entindex(), 0, null, null)
        // printl("(P2:MM): Renamed predicted_viewmodel to viewmodel_player" + ent.GetRootMoveParent().entindex())
        // printl("" + ent.GetRootMoveParent().entindex() + " rotation " + ent.GetAngles())
        // printl("" + ent.GetRootMoveParent().entindex() + "    origin " + ent.GetOrigin())
    }

    // If the player is the first player to join, fix OrangeOldPlayerPos
    if (p.GetTeam() == 2) {
        if (OrangeCacheFailed==true) {
            OrangeOldPlayerPos <- p.GetOrigin()
            OrangeCacheFailed <- false
        }
    }

    // Run general map code after a player loads into the game
    if (PlayerID == 1) {
        PostMapLoad()
    }

    // Run code after player 2 joins
    if (PlayerID == 2) {
        PostPlayer2Join()
    }

    //# Set cvars on joining players' client #//
    SendToConsole("sv_timeout 3")
    EntFireByHandle(clientcommand, "Command", "stopvideos", 0, p, p)
    EntFireByHandle(clientcommand, "Command", "r_portal_fastpath 0", 0, p, p)
    EntFireByHandle(clientcommand, "Command", "r_portal_use_pvs_optimization 0", 0, p, p)
    MapSupport(false, false, false, false, true, false, false)

    //# Say join message on HUD #//
    if (PluginLoaded==true) {
        JoinMessage <- GetPlayerName(PlayerID) + " joined the game"
    } else {
        JoinMessage <- "Player " + PlayerID + " joined the game"
    }
    // Set join message to player name
    JoinMessage = JoinMessage.tostring()
    joinmessagedisplay.__KeyValueFromString("message", JoinMessage)
    EntFireByHandle(joinmessagedisplay, "display", "", 0.0, null, null)
    if (PlayerID >= 2) {
        onscreendisplay.__KeyValueFromString("y", "0.075")
        CreatePortalsLinkedProp(portal1, portal2, p)
    }

    //# Set player color #//

    // Set a random color for clients that join after 16 have joined
    local pcolor = GetPlayerColor(p, false)

    // Set color of player's in-game model
    script_scope.Colored <- true
    EntFireByHandle(p, "Color", (pcolor.r + " " + pcolor.g + " " + pcolor.b), 0, null, null)

    //# Setup player class #//
    local currentplayerclass = {}

    // Player
    currentplayerclass.player <- p
    // Player id
    currentplayerclass.id <- p.entindex()
    // Player name
    if (PluginLoaded==true) {
        currentplayerclass.username <- GetPlayerName(p.entindex())
        player1discordhookstr = "hookdiscord Player " + currentplayerclass.username + " Joined The Game"
        player1discordhookstr.tostring()
        EntFire("p232servercommand", "command", "script SendPythonOutput(player1discordhookstr)", 1)
    } else {
        currentplayerclass.username <- "Player " + p.entindex()
    }
    // Player angles
    currentplayerclass.eyeangles <- Vector(0, 0, 0)
    currentplayerclass.eyeforwardvector <- Vector(0, 0, 0)

    SetCosmetics(p)

    // Potatogun
    currentplayerclass.potatogun <- false

    // Player color
    local localcolorclass = {}
    localcolorclass.r <- R
    localcolorclass.g <- G
    localcolorclass.b <- B
    currentplayerclass.color <- localcolorclass
    // Player noclip status
    currentplayerclass.noclip <- p.IsNoclipping()
    // Rocket player status
    currentplayerclass.rocket <- false

    currentplayerclass.portal1 <- portal1
    currentplayerclass.portal2 <- portal2

    // Make sure there isnt an existing player class
    foreach (indx, curlclass in playerclasses) {
        if (curlclass.player == p) {
            // If there is, remove it
            playerclasses.remove(indx)
        }
    }

    // Add player class to the player class array
    playerclasses.push(currentplayerclass)

    printl("===== Player Class =====")
    foreach (thing in FindPlayerClass(p)) {
        printl(thing)
    }
    printl("===================")

    // Set fog controller
    if (HasSpawned==true) {
        if (usefogcontroller == true) {
            EntFireByHandle(p, "setfogcontroller", defaultfog, 0, null, null)
        }
    }
}

//////////////////////
// RUNS AFTER DEATH //
//////////////////////

function OnPlayerDeath(player) {
    if (GetDeveloperLevel() == 1) {
        printl("(P2:MM): Player died!")
        MapSupport(false, false, false, false, false, player, false)
    }
}

////////////////////////
// RUNS AFTER RESPAWN //
////////////////////////

function OnPlayerRespawn(player) {
    // GlobalSpawnClass teleport
    if (GlobalSpawnClass.useautospawn == true) {
        TeleportToSpawnPoint(player, null)
    }

    MapSupport(false, false, false, false, false, false, player)

    if (GetDeveloperLevel() == 1) {
        printl("(P2:MM): Player respawned!")
    }
}

///////////////////////////////////////
// RUNS AFTER BLUE INITALLY LOADS IN //
///////////////////////////////////////

function PostMapLoad() {
    //# Discord Hook #//
    SendPythonOutput("hookdiscord Portal 2 Playing On: " + GetMapName())

    //## Cheat detection ##//
    SendToConsole("prop_dynamic_create cheatdetectionp232")
    SendToConsole("script SetCheats()")

    // Add a hook to the chat command function
    if (PluginLoaded==true) {
        printl("(P2:MM): Plugin Loaded")
        AddChatCallback("ChatCommands")
    }
    // Edit cvars
    SendToConsole("mp_allowspectators 0")
    // Force spawn players in map
    AddBranchLevelName( 1, "P2 32" )
    MapSupport(false, false, false, true, false, false, false)
    CreatePropsForLevel(true, false, false)
    // Enable fast download
    SendToConsole("sv_downloadurl \"https://github.com/kyleraykbs/Portal2-32PlayerMod/raw/main/WebFiles/FastDL/portal2/\"")
    SendToConsole("sv_allowdownload 1")
    SendToConsole("sv_allowupload 1")
    if (DevMode==true) {
        SendToConsole("developer 1")
        StartDevModeCheck <- true
    }

    if (RandomTurrets==true) {
        PrecacheModel("npcs/turret/turret_skeleton.mdl")
        PrecacheModel("npcs/turret/turret_backwards.mdl")
    }

	// Gelocity alias, put gelocity1(2,or 3) into console to easier changelevel
	SendToConsole("alias gelocity1 changelevel workshop/596984281130013835/mp_coop_gelocity_1_v02")
	SendToConsole("alias gelocity2 changelevel workshop/594730048530814099/mp_coop_gelocity_2_v01")
	SendToConsole("alias gelocity3 changelevel workshop/613885499245125173/mp_coop_gelocity_3_v02")

    // Set original angles
    EntFire("p232servercommand", "command", "script CanCheckAngle <- true", 0.32)

    local plr = Entities.FindByClassname(null, "player")
    // OriginalPosMain <- Entities.FindByClassname(null, "player").GetOrigin()
    // Entities.FindByClassname(null, "player").SetOrigin(Vector(plr.GetOrigin().x + 0.24526, plr.GetOrigin().y + 0.23458, OriginalPosMain.z + 0.26497))

    plr.SetHealth(230053963)

    EntFireByHandle(plr, "addoutput", "MoveType 8", 0, null, null)

    EntFire("p232servercommand", "command", "script Entities.FindByName(null, \"blue\").SetHealth(230053963)", 0.9)
    EntFire("p232servercommand", "command", "script CanHook <- true", 1)
    PostMapLoadDone <- true
}

///////////////////////////////
// RUNS AFTER PLAYER 2 JOINS //
///////////////////////////////

function PostPlayer2Join() {
    if (!CheatsOn) {
        SendToConsole("sv_cheats 0")
    }
    Player2Joined <- true
}

//////////////////////////////////////
// RUNS AFTER EVERYONE FIRST SPAWNS //
//////////////////////////////////////

function GeneralOneTime() {
    EntFire("p232servercommand", "command", "script ForceRespawnAll()", 1)

    // Single player maps with chapter titles
    local CHAPTER_TITLES =
    [
        { map = "sp_a1_intro1", title_text = "#portal2_Chapter1_Title", subtitle_text = "#portal2_Chapter1_Subtitle", displayOnSpawn = false,		displaydelay = 1.0 },
        { map = "sp_a2_laser_intro", title_text = "#portal2_Chapter2_Title", subtitle_text = "#portal2_Chapter2_Subtitle", displayOnSpawn = true,	displaydelay = 2.5 },
        { map = "sp_a2_sphere_peek", title_text = "#portal2_Chapter3_Title", subtitle_text = "#portal2_Chapter3_Subtitle", displayOnSpawn = true,	displaydelay = 2.5 },
        { map = "sp_a2_column_blocker", title_text = "#portal2_Chapter4_Title", subtitle_text = "#portal2_Chapter4_Subtitle", displayOnSpawn = true, displaydelay = 2.5 },
        { map = "sp_a2_bts3", title_text = "#portal2_Chapter5_Title", subtitle_text = "#portal2_Chapter5_Subtitle", displayOnSpawn = true,			displaydelay = 1.0 },
        { map = "sp_a3_00", title_text = "#portal2_Chapter6_Title", subtitle_text = "#portal2_Chapter6_Subtitle", displayOnSpawn = true,			displaydelay = 1.5 },
        { map = "sp_a3_speed_ramp", title_text = "#portal2_Chapter7_Title", subtitle_text = "#portal2_Chapter7_Subtitle", displayOnSpawn = true,	displaydelay = 1.0 },
        { map = "sp_a4_intro", title_text = "#portal2_Chapter8_Title", subtitle_text = "#portal2_Chapter8_Subtitle", displayOnSpawn = true,			displaydelay = 2.5 },
        { map = "sp_a4_finale1", title_text = "#portal2_Chapter9_Title", subtitle_text = "#portal2_Chapter9_Subtitle", displayOnSpawn = false,		displaydelay = 1.0 },
    ]

    local ent = Entities.FindByName(null, "blue")
    local playerclass = FindPlayerClass(ent)
    CreatePortalsLinkedProp(playerclass.portal1, playerclass.portal2, ent)

    if (fogs == false) {
        usefogcontroller <- false
        printl("(P2:MM): No fog controller found, disabling fog controller")
    } else {
        usefogcontroller <- true
        printl("(P2:MM): Fog controller found, enabling fog controller")
    }

    if (usefogcontroller == true) {
        foreach (fog in fogs) {
            EntFireByHandle(Entities.FindByName(null, fog.name), "addoutput", "OnTrigger p232servercommand:command:script p232fogswitch(\"" + fog.fogname + "\")", 0, null, null)
        }

        defaultfog <- fogs[0].fogname

        local p = null
        while (p = Entities.FindByClassname(p, "player")) {
            EntFireByHandle(p, "setfogcontroller", defaultfog, 0, null, null)
        }
    }

    // Attempt to display chapter title
    foreach (index, level in CHAPTER_TITLES)
	{
		if (level.map == GetMapName() && level.displayOnSpawn )
		{
            foreach (index, level in CHAPTER_TITLES)
            {
                if (level.map == GetMapName() )
                {
                    EntFire( "@chapter_title_text", "SetTextColor", "210 210 210 128", 0.0 )
                    EntFire( "@chapter_title_text", "SetTextColor2", "50 90 116 128", 0.0 )
                    EntFire( "@chapter_title_text", "SetPosY", "0.32", 0.0 )
                    EntFire( "@chapter_title_text", "SetText", level.title_text, 0.0 )
                    EntFire( "@chapter_title_text", "display", "", level.displaydelay )

                    EntFire( "@chapter_subtitle_text", "SetTextColor", "210 210 210 128", 0.0 )
                    EntFire( "@chapter_subtitle_text", "SetTextColor2", "50 90 116 128", 0.0 )
                    EntFire( "@chapter_subtitle_text", "SetPosY", "0.35", 0.0 )
                    EntFire( "@chapter_subtitle_text", "settext", level.subtitle_text, 0.0 )
                    EntFire( "@chapter_subtitle_text", "display", "", level.displaydelay )
                }
            }
		}
	}

    // Clear all cached models from our temp cache as they are already cached
    // CanClearCache <- true

    // Set a variable to tell the map loaded
    HasSpawned <- true

    // Cache orange players original position
    local p = null
    while (p = Entities.FindByClassname(p, "player")) {
        if (p.GetTeam()==2) {
            OrangeOldPlayerPos <- p.GetOrigin()
        }
    }
    try {
        if (OrangeOldPlayerPos) { }
    } catch(exeption) {
        if (GetDeveloperLevel() == 1) {
            printl("(P2:MM): OrangeOldPlayerPos not set (Blue probably moved before Orange could load in) Setting OrangeOldPlayerPos to BlueOldPlayerPos")
        }
        OrangeOldPlayerPos <- OldPlayerPos
        OrangeCacheFailed <- true
    }

    // Force open the blue player droppers
    try {
        local ent = null
        while(ent = Entities.FindByClassnameWithin(ent, "prop_dynamic", Vector(OldPlayerPos.x, OldPlayerPos.y, OldPlayerPos.z-300), 100)) {
            if (ent.GetModelName() == "models/props_underground/underground_boxdropper.mdl" || ent.GetModelName() == "models/props_backstage/item_dropper.mdl") {
                EntFireByHandle(ent, "setanimation", "open", 0, null, null)
                if (ent.GetModelName() == "models/props_backstage/item_dropper.mdl") {
                    EntFireByHandle(ent, "setanimation", "item_dropper_open", 0, null, null)
                }
                ent.__KeyValueFromString("targetname", "BlueDropperForcedOpenMPMOD")
            }
        }
    } catch(exeption) {
        if (GetDeveloperLevel() == 1) {
            printl("(P2:MM): Blue dropper not found!")
        }
    }

    // Force open the red player droppers
    printl(OrangeOldPlayerPos)
    printl(OldPlayerPos)

    local radius = 150

    if (OrangeCacheFailed==true) {
        radius = 350
    }

    try {
        local ent = null
        while(ent = Entities.FindByClassnameWithin(ent, "prop_dynamic", Vector(OrangeOldPlayerPos.x, OrangeOldPlayerPos.y, OldPlayerPos.z-300), radius)) {
            if (ent.GetModelName() == "models/props_underground/underground_boxdropper.mdl" || ent.GetModelName() == "models/props_backstage/item_dropper.mdl") {
                EntFireByHandle(ent, "setanimation", "open", 0, null, null)
                if (ent.GetModelName() == "models/props_backstage/item_dropper.mdl") {
                    EntFireByHandle(ent, "setanimation", "item_dropper_open", 0, null, null)
                }
                ent.__KeyValueFromString("targetname", "RedDropperForcedOpenMPMOD")
            }
        }
    } catch(exeption) {
        if (GetDeveloperLevel() == 1) {
            printl("(P2:MM): Red dropper not found!")
        }
    }
    local radius = null

    //# Attempt to fix some general map issues #//
    local DoorEntities = [
        "airlock_1-door1-airlock_entry_door_close_rl",
        "airlock_2-door1-airlock_entry_door_close_rl",
        "last_airlock-door1-airlock_entry_door_close_rl",
        "airlock_1-door1-door_close",
        "airlock1-door1-door_close",
        "camera_door_3-relay_doorclose",
        "entry_airlock-door1-airlock_entry_door_close_rl",
        "door1-airlock_entry_door_close_rl",
        "airlock-door1-airlock_entry_door_close_rl",
        "orange_door_1-ramp_close_start",
        "blue_door_1-ramp_close_start",
        "orange_door_1-airlock_player_block",
        "blue_door_1-airlock_player_block",
        "airlock_3-door1-airlock_entry_door_close_rl",  //mp_coop_sx_bounce (Sixense map)
    ]

    if (IsOnSingleplayer == false) {
        foreach (DoorType in DoorEntities) {
            try {
                Entities.FindByName(null, DoorType).Destroy()
            } catch(exception) { }
        }
    }

    // Create props after cache
    SendToConsole("script CreatePropsForLevel(false, true, false)")

    MapSupport(false, false, true, false, false, false, false)
}

///////////////////
// CHAT COMMANDS //
///////////////////

function ChatCommands(ccuserid, ccmessage) {
    // Get all nessasary data
    local p = FindByIndex(ccuserid)
    local pname = GetPlayerName(ccuserid)
    local adminlevel = GetAdminLevel(ccuserid)
    local message = split(ccmessage, " ")
    local commandrunner = p
    // Print some debug info
    if (GetDeveloperLevel() == 1) {
        printl("=========" + pname + " sent a message=========")

        printl("ccuserid: " + ccuserid)
        printl("ccmessage: " + ccmessage)
        printl("p: " + p)
        printl("pname: " + pname)
        printl("adminlevel: " + adminlevel)
        printl("message: " + message)
    }

    // Setup the message
    local indx = -1
    local isparseingname = false // Used to check if we are parsing a name
    local isparsingcommand = false // Used to check if we are parsing a command
    local parsedname = ""
    local parsedcommand = ""
    foreach (submessage in message) {
        submessage = lstrip(submessage)
        indx++
        // If the message starts with a $, then it's a player override
        if (strip(submessage).slice(0,1) == "$" || isparseingname == true && strip(submessage).slice(0,1) != "!") {
            // Make sure we update the parse list
            isparseingname = true
            isparsingcommand = false

            // Get the name itself
            local playeroverride = submessage
            if (submessage.slice(0,1) == "$") {
                playeroverride = submessage.slice(1)
            }

            // Add it to the parsed name
            parsedname = parsedname + playeroverride + " "
        }

        // If the message starts with a !, then it's a command
        if (strip(submessage).slice(0,1) == "!" || isparsingcommand == true && strip(submessage).slice(0,1) != "$") {
            isparseingname = false
            isparsingcommand = true

            // Get the command itself
            local command = submessage
            if (submessage.slice(0,1) == "!") {
                command = submessage.slice(1)
            }

            // Add it to the parsed command
            parsedcommand = parsedcommand + command + " "
        }
    }

    // Strip the last space from the parsed name
    if (parsedname != "") {
        parsedname = strip(parsedname)
        printl("parsed name: " + ExpandName(parsedname))
        pname = ExpandName(parsedname)
        commandrunner = p // Set the commandrunner to the player that sent the command
        p = FindPlayerByName(ExpandName(parsedname))
        printl("expanded name: " + pname)
        printl("executing on: " + p)
    }
    // Strip the last space from the parsed command
    if (parsedcommand != "") {
        parsedcommand = parsedcommand.slice(0, -1)
        printl("parsed command: " + parsedcommand)
        // If it's all
        if (pname != "all") {
            // Run the chat command runner if the player isnt null
            if (p != null) {
                adminlevel = adminlevel.tointeger() // Make sure the adminlevel is an integer
                if (adminlevel > 1) {
                    ChatCommandRunner(p, pname, parsedcommand, adminlevel, commandrunner)
                }
            }
        } else {
            // If its high enough to use all
            if (adminlevel > 1) {
                // Run the chat command for all players
                local p2 = null
                while (p2 = Entities.FindByClassname(p2, "player")) {
                    adminlevel = adminlevel.tointeger() // Make sure the adminlevel is an integer
                    if (adminlevel > 1) {
                        local newpname = GetPlayerName(p2.entindex())
                        ChatCommandRunner(p2, newpname, parsedcommand, adminlevel, commandrunner)
                    }
                }
            } else {
                SendToConsole("say " + playername + ": You cant use all.")
            }
        }
    }

    printl("==============================================")
}

function ChatCommandRunner(player, playername, command, level, commandrunner = null) {
    // Do some variable setup
    if (commandrunner == null) {
        commandrunner = player
    }
    // Split up the command
    command = split(command, " ")
    local action = command[0]
    local currentplayerclass = FindPlayerClass(player)

    //## Check for the command ##//

    //## NOCLIP ##//
    if (action == "noclip") {
        // Update the player's noclip status
        currentplayerclass.noclip <- player.IsNoclipping()
        // Inverse the noclip status unless there is a second argument
        if (command.len() < 2) {
            if (currentplayerclass.noclip == false) {
                EntFireByHandle(player, "addoutput", "MoveType 8", 0, null, null)
                currentplayerclass.noclip <- true
            } else {
                EntFireByHandle(player, "addoutput", "MoveType 2", 0, null, null)
                currentplayerclass.noclip <- false
            }
        } else {
            // Set the noclip status to the second argument
            if (command[1] == "on") {
                EntFireByHandle(player, "addoutput", "MoveType 8", 0, null, null)
                currentplayerclass.noclip <- true
            } else if (command[1] == "off") {
                EntFireByHandle(player, "addoutput", "MoveType 2", 0, null, null)
                currentplayerclass.noclip <- false
            }
        }
    }

    //## SPEED ##//
    if (action == "speed") {
        if (command.len() > 1) {
            EntFire("p232_player_speedmod", "modifyspeed", command[1], 0, player)
        } else {
            SendToConsole("say " + playername + ": You need to specify a speed.")
        }
    }

    //## KICK ##//
    if (action == "kick") {
        if (command.len() < 2) {
            if (commandrunner == player) {
                SendToConsole("say " + playername + ": You probably dont want to kick yourself. If you do then use kick " + playername + ".")
            } else {
                EntFire("p232clientcommand", "command", "disconnect", 0, player)
            }
        } else {
            local reason = ""
            if (command.len() > 2) {
                reason = " \"" + CombineList(command, 2) + "\""
            }
            local playertokick = FindPlayerByName(command[1])
            if (playertokick != null) {
                EntFire("p232clientcommand", "command", "disconnect" + reason, 0, playertokick)
            } else {
                SendToConsole("say " + playername + ": " + command[1] + " is not a valid player.")
            }
        }
    }

    //## KILL ##//
    if (action == "kill") {
        if (command.len() < 2) {
            EntFireByHandle(player, "sethealth", "-9999999999999999999999999999999999999999999999999", 0, player, player)
        } else {
            local nm = ExpandName(command[1])
            local playertorun = FindPlayerByName(command[1])
            if (command[1] == "all") {
                local p2 = null
                while (p2 = Entities.FindByClassname(p2, "player")) {
                    EntFireByHandle(p2, "sethealth", "-9999999999999999999999999999999999999999999999999", 0, player, player)
                }
                SendToConsole("say " + playername + ": Killed all players.")
            } else {
                if (playertorun != null) {
                    EntFireByHandle(playertorun, "sethealth", "-9999999999999999999999999999999999999999999999999", 0, player, player)
                    SendToConsole("say " + playername + ": " + nm + " has been killed.")
                } else {
                    SendToConsole("say " + playername + ": " + command[1] + " is not a valid player.")
                }
            }
        }
    }

    //## ROCKET ##//
    if (action == "rocket") {
        if (command.len() < 2) {
            currentplayerclass.rocket <- !currentplayerclass.rocket
            //EntFireByHandle(player, "sethealth", "-9999999999999999999999999999999999999999999999999", 5, player, player)
            player.SetVelocity(Vector(player.GetVelocity().x, player.GetVelocity().y, 1000))
        } else {
            local playertorun = FindPlayerByName(command[1])
            if (playertorun != null) {
                local tempplayerclass = FindPlayerClass(playertorun)
                tempplayerclass.rocket <- !tempplayerclass.rocket
                playertorun.SetVelocity(Vector(playertorun.GetVelocity().x, playertorun.GetVelocity().y, 1000))
                //EntFireByHandle(playertorun, "sethealth", "-9999999999999999999999999999999999999999999999999", 5, player, player)
            } else {
                SendToConsole("say " + playername + ": " + command[1] + " is not a valid player.")
            }
        }
    }

    //## SLAP ##//
    if (action == "slap") {
        if (command.len() < 2) {
            EntFireByHandle(player, "sethealth", "5", 0, player, player)
            player.SetVelocity(Vector(RandomInt(-200, 200), RandomInt(-200, 200), RandomInt(200, 500)))
        } else {
            local playertorun = FindPlayerByName(command[1])
            if (playertorun != null) {
                EntFireByHandle(playertorun, "sethealth", "5", 0, player, player)
                playertorun.SetVelocity(Vector(RandomInt(-200, 200), RandomInt(-200, 200), RandomInt(200, 500)))
            } else {
                SendToConsole("say " + playername + ": " + command[1] + " is not a valid player.")
            }
        }
    }

    //## BRING ##//
    if (action == "bring") {
        if (command.len() < 2) {
            SendToConsole("say " + playername + ": You need to specify a player to bring.")
        } else {
            if (command[1] == "all") {
                local p2 = null
                while (p2 = Entities.FindByClassname(p2, "player")) {
                    p2.SetOrigin(player.GetOrigin())
                }
                SendToConsole("say " + playername + ": All players have been brought to you.")
            } else {
                local nm = ExpandName(command[1])
                local playertorun = FindPlayerByName(command[1])
                if (playertorun != null) {
                    playertorun.SetOrigin(player.GetOrigin())
                    SendToConsole("say " + playername + ": " + nm + " has been brought.")
                } else {
                    SendToConsole("say " + playername + ": " + nm + " is not a valid player.")
                }
            }
        }
    }

    //## GOTO / TELEPORT ##//
    if (action == "goto" || action == "teleport") {
        if (command.len() < 2) {
            SendToConsole("say " + playername + ": You need to specify a player to teleport to.")
        } else {
            local nm = ExpandName(command[1])
            local playertorun = FindPlayerByName(command[1])
            if (playertorun != null) {
                player.SetOrigin(playertorun.GetOrigin())
                SendToConsole("say " + playername + ": You have been teleported to " + nm + ".")
            } else {
                SendToConsole("say " + playername + ": " + nm + " is not a valid player.")
            }
        }
    }

    //## RCON ##//
    if (action == "rcon") {
        if (command.len() < 2) {
            SendToConsole("say " + playername + ": You need to specify a command to run.")
        } else {
            local commandtosend = CombineList(command, 2)
            SendToConsole(commandtosend)
        }
    }

    //## CHANGELEVEL ##//
    if (action == "changelevel") {
        if (command.len() < 2) {
            SendToConsole("say " + playername + ": You need to specify a map to change to.")
        } else {
            local mapname = CombineList(command, 2)
            SendToConsole("changelevel " + mapname)
        }
    }

    //## SPECTATE ##//
    if (action == "spectate") {
        if (command.len() < 2) {
            local currentplayerclass = FindPlayerClass(player)
        } else {

        }
    }

    //## GETPLAYER ##//
    if (action == "getplayer") {
        if (command.len() < 2) {
            SendToConsole("say " + playername + ": You need to specify a player name to get.")
        } else {
            local nm = ExpandName(command[1])
            local playertorun = FindPlayerByName(command[1])
            if (playertorun != null) {
                SendToConsole("say " + playername + ": " + nm + "'s index is " + playertorun.entindex() + ".")
            } else {
                SendToConsole("say " + playername + ": " + nm + " is not a valid player.")
            }
        }
    }
}