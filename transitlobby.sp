#include <sourcemod>
#include <sdktools>

#define PLUGIN_NAME "TransitLobby"
#define AUTHOR "時光會凝聚嗎"
#define VERSION "0.1"

Handle cvar_transit_switcher;
Handle cvar_transit_server;
int transit_switcher = 1;
char transit_server[] = "";

public Plugin myinfo =
{
    name = PLUGIN_NAME,
    author = AUTHOR,
    description = "Curing The DDOS One Plugin At A Time",
    version = VERSION,
    url = "https://github.com/T1me/TransitLobby"
}

public void OnPluginStart()
{
    cvar_transit_switcher = CreateConVar("l4d_transit_switcher", "1", "1: Enable; 0: Disable.");
    cvar_transit_server = CreateConVar("l4d_transit_server", "", "The server redirect to");
    AutoExecConfig(true, "transitlobby");

    HookConVarChange(cvar_transit_switcher, SwitcherCovert);
    HookConVarChange(cvar_transit_server, ServerCovert);

    transit_switcher = GetConVarInt(cvar_transit_switcher);
    GetConVarString(cvar_transit_server, transit_server, 128);


    Switcher();
}

static Switcher()
{
    if (!transit_switcher) return;
    if (transit_switcher > 0) HookEvent("pills_used", RedirectClient);
}

public SwitcherCovert(Handle cvar, const String:oldValue[], const String:newValue[])
{
    transit_switcher = GetConVarInt(cvar_transit_switcher);
}

public ServerCovert(Handle cvar, const String:oldValue[], const String:newValue[])
{
    GetConVarString(cvar_transit_server, transit_server, 128);
}

public Action RedirectClient(Event event, const String:name[], bool:dontBroadcast)
{
    int player = GetClientOfUserId(event.GetInt("userid"));
    DisplayAskConnectBox(player, 10.0, transit_server, "");
    return Plugin_Handled;
}
