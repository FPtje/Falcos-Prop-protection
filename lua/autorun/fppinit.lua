if SERVER then
    AddCSLuaFile()

    include("config/mysql.lua")
    include("libraries/mysqlite/mysqlite.lua")

    include("libraries/sh_cami.lua")
    include("fpp/sh_cppi.lua")
    include("fpp/sh_settings.lua")

    include("fpp/server/defaultblockedmodels.lua")
    include("fpp/server/settings.lua")
    include("fpp/server/core.lua")
    include("fpp/server/antispam.lua")
    include("fpp/server/ownability.lua")

    AddCSLuaFile("fpp/client/menu.lua")
    AddCSLuaFile("fpp/client/hud.lua")
    AddCSLuaFile("fpp/client/buddies.lua")
    AddCSLuaFile("fpp/client/ownability.lua")

    AddCSLuaFile("libraries/sh_cami.lua")
    AddCSLuaFile("fpp/sh_cppi.lua")
    AddCSLuaFile("fpp/sh_settings.lua")

    if FPP_MySQLConfig and FPP_MySQLConfig.EnableMySQL then
        hook.Add("DatabaseInitialized", "FPP Init", FPP.Init)
        MySQLite.connectToMySQL(FPP_MySQLConfig.Host, FPP_MySQLConfig.Username, FPP_MySQLConfig.Password, FPP_MySQLConfig.Database_name, FPP_MySQLConfig.Database_port)
    else
        FPP.Init()
    end
elseif CLIENT then
    include("fpp/client/menu.lua")
    include("fpp/client/hud.lua")
    include("fpp/client/buddies.lua")
    include("fpp/client/ownability.lua")

    include("libraries/sh_cami.lua")
    include("fpp/sh_cppi.lua")
    include("fpp/sh_settings.lua")
end
