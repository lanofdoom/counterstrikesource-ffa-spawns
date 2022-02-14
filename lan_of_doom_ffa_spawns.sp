#include <sdktools>
#include <sourcemod>

public const Plugin myinfo = {
    name = "FFA Spawns", author = "LAN of DOOM",
    description = "Changes spawn points on a map when friendly fire is enabled",
    version = "0.8.0",
    url = "https://github.com/lanofdoom/counterstrikesource-ffa-spawns"};

static const float kPreferredDistanceToPlayer = 600.0;
static const float kMinimumDistanceToPlayer = 100.0;

static ConVar g_friendlyfire_cvar;

static ArrayList g_spawn_origins;
static ArrayList g_spawn_angles;

//
// Spawn Points
//

static void gg_aim_shotty() {
  g_spawn_origins.PushArray({-479.319305, -346.188293, 256.031250});
  g_spawn_origins.PushArray({-479.319305, -346.188293, 256.031250});
  g_spawn_origins.PushArray({-375.153809, 57.789165, 256.031250});
  g_spawn_origins.PushArray({-57.793209, 80.931259, 216.031250});
  g_spawn_origins.PushArray({-64.034508, -0.265878, 128.031250});
  g_spawn_origins.PushArray({-167.354858, -448.716858, 216.031250});
  g_spawn_origins.PushArray({-213.461060, -331.371643, 128.031250});
  g_spawn_origins.PushArray({183.109543, -351.491882, 256.031250});
  g_spawn_origins.PushArray({139.931580, 43.863850, 256.031250});
  g_spawn_origins.PushArray({-727.182312, -440.954803, 128.031250});
  g_spawn_origins.PushArray({-552.085144, -214.187454, 128.031250});
  g_spawn_origins.PushArray({-751.968750, -56.484768, 141.884628});
  g_spawn_origins.PushArray({-751.968750, 61.807976, 140.687637});
  g_spawn_origins.PushArray({495.968750, 52.730381, 268.031250});
  g_spawn_origins.PushArray({495.987213, -526.633667, 268.031250});
  g_spawn_origins.PushArray({272.031250, -158.680542, 128.031250});
  g_spawn_origins.PushArray({458.724701, -338.401123, 128.031250});
  g_spawn_origins.PushArray({307.607361, -208.031250, 128.031250});
  g_spawn_origins.PushArray({-751.989685, -701.640503, 268.031250});
  g_spawn_origins.PushArray({-751.999268, 323.643799, 268.031250});
  g_spawn_origins.PushArray({-528.031250, -159.968750, 128.031250});
  g_spawn_origins.PushArray({444.527893, 32.031250, 128.031250});
  g_spawn_origins.PushArray({272.031250, 27.812572, 128.031250});
  g_spawn_origins.PushArray({-699.403809, -339.628845, 128.031250});
  g_spawn_origins.PushArray({-529.165222, -376.902069, 128.031250});
  g_spawn_origins.PushArray({-727.297607, 367.968750, 139.227921});
  g_spawn_origins.PushArray({-223.968750, -101.524330, 128.031250});
  g_spawn_origins.PushArray({42.464027, -192.902557, 256.031250});
  g_spawn_origins.PushArray({-262.473236, -184.145264, 256.031250});

  for (int i = 0; i < g_spawn_origins.Length; i++) {
    g_spawn_angles.PushArray({0.0, 0.0, 0.0});
  }
}

//
// Logic
//

static void LoadSpawnPoints() {
  g_spawn_origins.Clear();
  g_spawn_angles.Clear();

  char map_name[PLATFORM_MAX_PATH];
  GetCurrentMap(map_name, PLATFORM_MAX_PATH);

  if (StrEqual(map_name, "gg_aim_shotty")) {
    gg_aim_shotty();
  }

  if (g_spawn_origins.Length != g_spawn_angles.Length) {
    ThrowError("Unequal number of spawn origins and spawn angles");
  }
}

static void FilterSpawnPoints(int spawning_client, float min_distance,
                              ArrayList origins, ArrayList angles) {
  origins.Clear();
  angles.Clear();

  for (int i = 0; i < g_spawn_origins.Length; i++) {
    float xyz[3];
    g_spawn_origins.GetArray(i, xyz);

    bool add_to_list = true;
    for (int other_client = 1; other_client <= MaxClients; other_client++) {
      if (spawning_client == other_client || !IsClientInGame(other_client)) {
        continue;
      }

      float other_location[3];
      GetClientAbsOrigin(other_client, other_location);

      float x = xyz[0] - other_location[0];
      float y = xyz[1] - other_location[1];
      float z = xyz[2] - other_location[2];

      float distance = SquareRoot(x * x + y * y + z * z);
      if (distance < min_distance) {
        add_to_list = false;
        break;
      }
    }

    if (add_to_list) {
      origins.PushArray(xyz);
      g_spawn_angles.GetArray(i, xyz);
      angles.PushArray(xyz);
    }
  }
}

//
// Hooks
//

static Action OnPlayerSpawn(Handle event, const char[] name,
                            bool dontBroadcast) {
  if (!g_friendlyfire_cvar.BoolValue || g_spawn_origins.Length == 0) {
    return Plugin_Continue;
  }

  int userid = GetEventInt(event, "userid");
  if (!userid) {
    return Plugin_Continue;
  }

  int client = GetClientOfUserId(userid);
  if (!client) {
    return Plugin_Continue;
  }

  ArrayList origins = CreateArray(3);
  ArrayList angles = CreateArray(3);
  FilterSpawnPoints(client, kPreferredDistanceToPlayer, origins, angles);
  if (origins.Length == 0) {
    FilterSpawnPoints(client, kMinimumDistanceToPlayer, origins, angles);
  }

  float origin[3];
  float angle[3];
  if (origins.Length == 0) {
    int spawn_index = GetRandomInt(0, g_spawn_origins.Length - 1);
    g_spawn_origins.GetArray(spawn_index, origin);
    g_spawn_angles.GetArray(spawn_index, angle);
  } else {
    int spawn_index = GetRandomInt(0, origins.Length - 1);
    origins.GetArray(spawn_index, origin);
    angles.GetArray(spawn_index, angle);
  }

  TeleportEntity(client, origin, angle, NULL_VECTOR);

  CloseHandle(origins);
  CloseHandle(angles);

  return Plugin_Continue;
}

//
// Forwards
//

public void OnPluginStart() {
  g_friendlyfire_cvar = FindConVar("mp_friendlyfire");
  g_spawn_origins = CreateArray(3, 0);
  g_spawn_angles = CreateArray(3, 0);

  LoadSpawnPoints();

  HookEvent("player_spawn", OnPlayerSpawn);
}

public void OnMapStart() { LoadSpawnPoints(); }