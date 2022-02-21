#include <cstrike>
#include <sdktools>
#include <sourcemod>

public const Plugin myinfo = {
    name = "FFA Spawns", author = "LAN of DOOM",
    description = "Changes spawn points on a map when friendly fire is enabled",
    version = "1.0.1",
    url = "https://github.com/lanofdoom/counterstrikesource-ffa-spawns"};

static const float kPreferredDistanceToPlayer = 600.0;
static const float kMinimumDistanceToPlayer = 100.0;

static ConVar g_friendlyfire_cvar;

static ArrayList g_spawn_origins;
static ArrayList g_spawn_angles;

//
// Spawn Points
//

static void gg_autumn() {
  g_spawn_origins.PushArray({-743.968750, -309.224670, -7.968750});
  g_spawn_origins.PushArray({-581.229248, -231.805053, -7.968750});
  g_spawn_origins.PushArray({-850.546264, -702.679016, -4.947021});
  g_spawn_origins.PushArray({-581.324462, -222.763778, -127.968750});
  g_spawn_origins.PushArray({-747.968750, -509.818511, -127.968750});
  g_spawn_origins.PushArray({-799.610656, -32.641620, -155.968750});
  g_spawn_origins.PushArray({-797.502563, 100.607650, -155.968750});
  g_spawn_origins.PushArray({-568.031250, 284.031250, -7.968750});
  g_spawn_origins.PushArray({-743.968750, 373.693359, -7.968750});
  g_spawn_origins.PushArray({-844.327514, 771.716186, -15.963692});
  g_spawn_origins.PushArray({722.494018, 762.401977, -13.061019});
  g_spawn_origins.PushArray({381.058227, 288.031250, -7.968750});
  g_spawn_origins.PushArray({723.851623, 750.265258, -14.337684});
  g_spawn_origins.PushArray({378.913909, 288.031250, -7.968750});
  g_spawn_origins.PushArray({549.625183, 369.176605, -7.968750});
  g_spawn_origins.PushArray({555.968750, 521.742431, -127.968750});
  g_spawn_origins.PushArray({607.968750, 104.643707, -155.968750});
  g_spawn_origins.PushArray({607.569824, -40.658668, -155.968750});
  g_spawn_origins.PushArray({555.997436, -503.968750, -127.968750});
  g_spawn_origins.PushArray({376.031250, -220.031250, -7.968750});
  g_spawn_origins.PushArray({551.640014, -304.549804, -7.968750});
  g_spawn_origins.PushArray({664.859924, -757.897766, -15.135843});
  g_spawn_origins.PushArray({-747.994567, 567.968750, -127.968750});
  g_spawn_origins.PushArray({551.968750, 368.126953, -7.968750});
  g_spawn_origins.PushArray({382.662322, 295.283935, -127.968750});
  g_spawn_origins.PushArray({368.314514, -360.058837, -127.968750});
  g_spawn_origins.PushArray({-560.470336, 430.209533, -127.968750});
  g_spawn_angles.PushArray({0.000000, -37.404006, 0.000000});
  g_spawn_angles.PushArray({0.000000, -124.391952, 0.000000});
  g_spawn_angles.PushArray({0.000000, 36.978141, 0.000000});
  g_spawn_angles.PushArray({0.000000, -143.663848, 0.000000});
  g_spawn_angles.PushArray({0.000000, 49.056095, 0.000000});
  g_spawn_angles.PushArray({0.000000, 0.480115, 0.000000});
  g_spawn_angles.PushArray({0.000000, -0.905884, 0.000000});
  g_spawn_angles.PushArray({0.000000, 131.196212, 0.000000});
  g_spawn_angles.PushArray({0.000000, 52.620269, 0.000000});
  g_spawn_angles.PushArray({0.000000, -54.101703, 0.000000});
  g_spawn_angles.PushArray({0.000000, -139.434555, 0.000000});
  g_spawn_angles.PushArray({0.000000, 62.957462, 0.000000});
  g_spawn_angles.PushArray({0.000000, -139.893859, 0.000000});
  g_spawn_angles.PushArray({0.000000, 55.040134, 0.000000});
  g_spawn_angles.PushArray({0.000000, 121.172172, 0.000000});
  g_spawn_angles.PushArray({0.000000, -135.207748, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.714141, 0.000000});
  g_spawn_angles.PushArray({0.000000, 178.526153, 0.000000});
  g_spawn_angles.PushArray({0.000000, 94.442184, 0.000000});
  g_spawn_angles.PushArray({0.000000, -50.097732, 0.000000});
  g_spawn_angles.PushArray({0.000000, -175.713745, 0.000000});
  g_spawn_angles.PushArray({0.000000, 131.270263, 0.000000});
  g_spawn_angles.PushArray({0.000000, -50.065555, 0.000000});
  g_spawn_angles.PushArray({0.000000, 129.920822, 0.000000});
  g_spawn_angles.PushArray({0.000000, 73.677223, 0.000000});
  g_spawn_angles.PushArray({0.000000, 3.524795, 0.000000});
  g_spawn_angles.PushArray({0.000000, -177.822647, 0.000000});
}

static void gg_factory() {
  g_spawn_origins.PushArray({-1017.669250, 228.093292, -271.968750});
  g_spawn_origins.PushArray({-974.367065, -528.374816, -271.968750});
  g_spawn_origins.PushArray({-976.376586, -607.265258, -271.968750});
  g_spawn_origins.PushArray({-1016.350158, -1433.852416, -271.968750});
  g_spawn_origins.PushArray({-409.608428, -1282.009155, -271.968444});
  g_spawn_origins.PushArray({-409.608428, -1282.009155, -271.968444});
  g_spawn_origins.PushArray({76.281372, -1176.184326, -271.968444});
  g_spawn_origins.PushArray({151.187805, -1018.659851, -271.968444});
  g_spawn_origins.PushArray({142.611511, -400.831298, -271.968444});
  g_spawn_origins.PushArray({52.889900, 63.118106, -271.968750});
  g_spawn_origins.PushArray({21.926088, 234.387542, -271.968750});
  g_spawn_origins.PushArray({270.981048, -155.669952, -271.968750});
  g_spawn_origins.PushArray({364.772979, 0.274704, -103.968750});
  g_spawn_origins.PushArray({211.272933, 224.888626, 0.031250});
  g_spawn_origins.PushArray({374.041900, -1144.860473, -103.968750});
  g_spawn_origins.PushArray({303.267242, -1041.932373, -271.968750});
  g_spawn_origins.PushArray({-93.950668, -1383.021606, 0.031250});
  g_spawn_origins.PushArray({-652.021545, -9.279073, 0.031250});
  g_spawn_origins.PushArray({-1040.533813, 228.586257, 0.031250});
  g_spawn_origins.PushArray({-1097.998901, -292.134918, 0.031250});
  g_spawn_origins.PushArray({-1097.992065, -884.707519, 0.031250});
  g_spawn_origins.PushArray({-996.733154, -1424.497802, 0.031250});
  g_spawn_origins.PushArray({-788.512145, -1229.938354, 0.031250});
  g_spawn_origins.PushArray({-548.622375, -1235.244750, 0.031250});
  g_spawn_origins.PushArray({-454.322753, -518.556518, 0.031250});
  g_spawn_origins.PushArray({-689.112731, -520.025512, 0.031250});
  g_spawn_origins.PushArray({29.057291, -1383.407714, -271.968444});
  g_spawn_origins.PushArray({-86.806549, 229.925262, 0.031250});
  g_spawn_origins.PushArray({255.422363, -1409.540893, 0.031250});
  g_spawn_angles.PushArray({0.000000, -35.111846, 0.000000});
  g_spawn_angles.PushArray({0.000000, 86.988113, 0.000000});
  g_spawn_angles.PushArray({0.000000, -89.627906, 0.000000});
  g_spawn_angles.PushArray({0.000000, 47.784202, 0.000000});
  g_spawn_angles.PushArray({0.000000, 176.010086, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.255920, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.718139, 0.000000});
  g_spawn_angles.PushArray({0.000000, 131.736099, 0.000000});
  g_spawn_angles.PushArray({0.000000, 136.752151, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.952056, 0.000000});
  g_spawn_angles.PushArray({0.000000, -178.697952, 0.000000});
  g_spawn_angles.PushArray({0.000000, -85.219375, 0.000000});
  g_spawn_angles.PushArray({0.000000, -90.469284, 0.000000});
  g_spawn_angles.PushArray({0.000000, -111.985328, 0.000000});
  g_spawn_angles.PushArray({0.000000, 88.786613, 0.000000});
  g_spawn_angles.PushArray({0.000000, 96.970710, 0.000000});
  g_spawn_angles.PushArray({0.000000, 90.208496, 0.000000});
  g_spawn_angles.PushArray({0.000000, -92.347358, 0.000000});
  g_spawn_angles.PushArray({0.000000, -58.651393, 0.000000});
  g_spawn_angles.PushArray({0.000000, 2.596640, 0.000000});
  g_spawn_angles.PushArray({0.000000, 0.088667, 0.000000});
  g_spawn_angles.PushArray({0.000000, 81.730682, 0.000000});
  g_spawn_angles.PushArray({0.000000, 91.168647, 0.000000});
  g_spawn_angles.PushArray({0.000000, 87.208679, 0.000000});
  g_spawn_angles.PushArray({0.000000, 87.406661, 0.000000});
  g_spawn_angles.PushArray({0.000000, 93.742576, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.912628, 0.000000});
  g_spawn_angles.PushArray({0.000000, -91.422111, 0.000000});
  g_spawn_angles.PushArray({0.000000, 120.108314, 0.000000});
}

static void gg_overpass() {
  g_spawn_origins.PushArray({325.000000, -1161.000000, -29.239999});
  g_spawn_origins.PushArray({-428.684997, 1145.000000, -10.239824});
  g_spawn_origins.PushArray({-1117.014282, 1437.274536, -227.191711});
  g_spawn_origins.PushArray({-1081.432373, 1072.711914, -218.967056});
  g_spawn_origins.PushArray({-1070.147827, 717.998657, -226.159439});
  g_spawn_origins.PushArray({-1585.780761, 281.567718, -36.370635});
  g_spawn_origins.PushArray({-1582.333862, 13.597072, -36.915008});
  g_spawn_origins.PushArray({-1573.027587, -304.947326, -38.423416});
  g_spawn_origins.PushArray({-990.418395, -1472.921875, -242.105651});
  g_spawn_origins.PushArray({1055.766845, -1477.105957, -228.699981});
  g_spawn_origins.PushArray({1099.776733, -998.244506, -225.733871});
  g_spawn_origins.PushArray({1489.664672, -349.689331, -52.545074});
  g_spawn_origins.PushArray({1484.280517, -6.737981, -66.713905});
  g_spawn_origins.PushArray({1485.355102, 313.747192, -53.245769});
  g_spawn_origins.PushArray({1380.548339, 775.449157, -80.737350});
  g_spawn_origins.PushArray({1021.369262, 1503.968750, -163.758712});
  g_spawn_origins.PushArray({-1012.409362, -1004.934570, -278.992095});
  g_spawn_origins.PushArray({-17.011083, 307.005279, -208.870315});
  g_spawn_origins.PushArray({-1104.871093, 393.674468, -233.979141});
  g_spawn_origins.PushArray({-1078.058837, 200.907806, -246.072235});
  g_spawn_origins.PushArray({-1099.142211, -215.033126, -235.817810});
  g_spawn_origins.PushArray({-1084.952514, -407.924163, -240.949951});
  g_spawn_origins.PushArray({1083.631958, -394.628967, -247.861434});
  g_spawn_origins.PushArray({1102.528686, -203.204330, -235.998229});
  g_spawn_origins.PushArray({1077.329711, 224.571807, -245.042007});
  g_spawn_origins.PushArray({1096.039672, 404.125762, -238.313827});
  g_spawn_origins.PushArray({1.541971, 301.592712, -507.800964});
  g_spawn_origins.PushArray({2.185809, -310.653259, -504.975494});
  g_spawn_origins.PushArray({16.990657, -304.721862, -208.968750});
  g_spawn_origins.PushArray({-1131.968750, 520.031250, -208.968750});
  g_spawn_origins.PushArray({1135.968750, 520.004028, -208.968750});
  g_spawn_origins.PushArray({1135.968750, -520.031250, -208.968750});
  g_spawn_origins.PushArray({-1131.984985, -520.000610, -208.968750});
  g_spawn_angles.PushArray({0.000000, 90.000000, 0.000000});
  g_spawn_angles.PushArray({0.000000, -90.000000, 0.000000});
  g_spawn_angles.PushArray({0.000000, -54.258071, 0.000000});
  g_spawn_angles.PushArray({0.000000, -43.697948, 0.000000});
  g_spawn_angles.PushArray({0.000000, 1.842104, 0.000000});
  g_spawn_angles.PushArray({0.000000, -1.229900, 0.000000});
  g_spawn_angles.PushArray({0.000000, 2.994098, 0.000000});
  g_spawn_angles.PushArray({0.000000, 1.674099, 0.000000});
  g_spawn_angles.PushArray({0.000000, -4.231366, 0.000000});
  g_spawn_angles.PushArray({0.000000, 151.428039, 0.000000});
  g_spawn_angles.PushArray({0.000000, 67.433807, 0.000000});
  g_spawn_angles.PushArray({0.000000, -174.714202, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.070266, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.664260, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.202209, 0.000000});
  g_spawn_angles.PushArray({0.000000, -177.552124, 0.000000});
  g_spawn_angles.PushArray({0.000000, 41.138305, 0.000000});
  g_spawn_angles.PushArray({0.000000, 1.576827, 0.000000});
  g_spawn_angles.PushArray({0.000000, -2.286853, 0.000000});
  g_spawn_angles.PushArray({0.000000, 0.419150, 0.000000});
  g_spawn_angles.PushArray({0.000000, 6.953053, 0.000000});
  g_spawn_angles.PushArray({0.000000, 0.419059, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.664916, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.939117, 0.000000});
  g_spawn_angles.PushArray({0.000000, -175.572998, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.675064, 0.000000});
  g_spawn_angles.PushArray({0.000000, 2.363110, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.969268, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.461608, 0.000000});
  g_spawn_angles.PushArray({0.000000, 23.324340, 0.000000});
  g_spawn_angles.PushArray({0.000000, 142.652359, 0.000000});
  g_spawn_angles.PushArray({0.000000, -164.841735, 0.000000});
  g_spawn_angles.PushArray({0.000000, -86.169754, 0.000000});
}

static void gg_xlighty() {
  g_spawn_origins.PushArray({1307.197998, 383.968750, 336.031250});
  g_spawn_origins.PushArray({-175.968750, -1279.968750, 336.031250});
  g_spawn_origins.PushArray({210.031250, -1230.759033, 528.031250});
  g_spawn_origins.PushArray({941.901306, 336.758453, 528.031250});
  g_spawn_origins.PushArray({179.333862, 383.993560, 576.031250});
  g_spawn_origins.PushArray({978.525756, -1279.997070, 576.031250});
  g_spawn_origins.PushArray({1506.461059, -699.269348, 552.031250});
  g_spawn_origins.PushArray({-330.141479, -195.694702, 552.031250});
  g_spawn_origins.PushArray({440.187011, -49.359043, 240.031250});
  g_spawn_origins.PushArray({711.842102, -50.193550, 240.031250});
  g_spawn_origins.PushArray({711.996704, -840.760009, 240.031250});
  g_spawn_origins.PushArray({440.013824, -834.127624, 240.031250});
  g_spawn_origins.PushArray({-255.932220, -451.792907, 396.031250});
  g_spawn_origins.PushArray({1385.754516, -447.004730, 384.031250});
  g_spawn_origins.PushArray({304.031250, -176.031250, 400.050567});
  g_spawn_origins.PushArray({847.968750, -176.031250, 400.050506});
  g_spawn_origins.PushArray({847.968750, -719.968750, 400.050506});
  g_spawn_origins.PushArray({304.031250, -719.968750, 400.049591});
  g_spawn_origins.PushArray({1283.559936, -572.895446, 720.031250});
  g_spawn_origins.PushArray({1319.558227, -571.182434, 336.031250});
  g_spawn_origins.PushArray({-158.488311, -323.833679, 336.031250});
  g_spawn_origins.PushArray({-152.997406, -322.384246, 720.031250});
  g_spawn_origins.PushArray({574.281921, -32.546058, 384.031250});
  g_spawn_origins.PushArray({577.867370, -849.985107, 384.031250});
  g_spawn_angles.PushArray({0.000000, -130.368164, 0.000000});
  g_spawn_angles.PushArray({0.000000, 51.497802, 0.000000});
  g_spawn_angles.PushArray({0.000000, -0.048216, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.507919, 0.000000});
  g_spawn_angles.PushArray({0.000000, -89.477958, 0.000000});
  g_spawn_angles.PushArray({0.000000, 89.880012, 0.000000});
  g_spawn_angles.PushArray({0.000000, -177.654067, 0.000000});
  g_spawn_angles.PushArray({0.000000, 1.074045, 0.000000});
  g_spawn_angles.PushArray({0.000000, -0.875954, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.435958, 0.000000});
  g_spawn_angles.PushArray({0.000000, 177.587997, 0.000000});
  g_spawn_angles.PushArray({0.000000, -3.912044, 0.000000});
  g_spawn_angles.PushArray({0.000000, 0.539930, 0.000000});
  g_spawn_angles.PushArray({0.000000, 179.597915, 0.000000});
  g_spawn_angles.PushArray({0.000000, -44.795261, 0.000000});
  g_spawn_angles.PushArray({0.000000, -138.183517, 0.000000});
  g_spawn_angles.PushArray({0.000000, 134.898376, 0.000000});
  g_spawn_angles.PushArray({0.000000, 43.044853, 0.000000});
  g_spawn_angles.PushArray({0.000000, -179.271926, 0.000000});
  g_spawn_angles.PushArray({0.000000, 177.427963, 0.000000});
  g_spawn_angles.PushArray({0.000000, 1.203616, 0.000000});
  g_spawn_angles.PushArray({0.000000, 0.279689, 0.000000});
  g_spawn_angles.PushArray({0.000000, 89.668426, 0.000000});
  g_spawn_angles.PushArray({0.000000, -88.453613, 0.000000});
}

static void LoadSpawnPoints() {
  g_spawn_origins.Clear();
  g_spawn_angles.Clear();

  char map_name[PLATFORM_MAX_PATH];
  GetCurrentMap(map_name, PLATFORM_MAX_PATH);

  if (StrEqual(map_name, "gg_autumn")) {
    gg_autumn();
  } else if (StrEqual(map_name, "gg_factory")) {
    gg_factory();
  } else if (StrEqual(map_name, "gg_overpass")) {
    gg_overpass();
  } else if (StrEqual(map_name, "gg_xlighty")) {
    gg_xlighty();
  }

  if (g_spawn_origins.Length != g_spawn_angles.Length) {
    ThrowError("Unequal number of spawn origins and spawn angles");
  }
}

//
// Logic
//

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

  int team = GetClientTeam(client);
  if (team != CS_TEAM_T && team != CS_TEAM_CT) {
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