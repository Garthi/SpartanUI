local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local L = LibStub("AceLocale-3.0"):GetLocale("SpartanUI", true);
local AceConfig = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local module = spartan:NewModule("Options");
---------------------------------------------------------------------------
local ModsLoaded =  {
	Artwork = nil,
	PlayerFrames = nil,
	PartyFrames = nil,
	RaidFrames = nil,
	SpinCam = nil,
	FilmEffects = nil
}

function module:OnInitialize()
	local name, title, notes, enabled,loadable = GetAddOnInfo("SpartanUI_Artwork")
	ModsLoaded.Artwork = enabled
	local name, title, notes, enabled,loadable = GetAddOnInfo("SpartanUI_PlayerFrames")
	ModsLoaded.PlayerFrames = enabled
	local name, title, notes, enabled,loadable = GetAddOnInfo("SpartanUI_PartyFrames")
	ModsLoaded.PartyFrames = enabled
	local name, title, notes, enabled,loadable = GetAddOnInfo("SpartanUI_RaidFrames")
	ModsLoaded.RaidFrames = enabled
	local name, title, notes, enabled,loadable = GetAddOnInfo("SpartanUI_SpinCam")
	ModsLoaded.SpinCam = enabled
	local name, title, notes, enabled,loadable = GetAddOnInfo("SpartanUI_FilmEffects")
	ModsLoaded.FilmEffects = enabled
	
	if (spartan.SpartanVer ~= spartan.CurseVersion) and (spartan.CurseVersion ~= "") then
		spartan.opt.args["General"].args["CurseVersion"] = {name = "Build "..spartan.CurseVersion,order=1.1,type = "header"};
	end

	spartan.opt.args["General"].args["style"] = {name = L["StyleSettings"], type = "group",order = 100,
		args = {
			description = {type="header",name=L["OverallStyle"],order=1},
			OverallStyle = { name = "", type = "group", inline=true,order=10, args = {
				Classic = {name = "Classic", type="execute",
					image=function() return "interface\\addons\\SpartanUI_Artwork\\Themes\\Classic\\Images\\base-center", 120, 60 end,
					func = function()
						DBMod.Artwork.Style = "Classic";
						DBMod.PlayerFrames.Style = DBMod.Artwork.Style;
						DBMod.PartyFrames.Style = DBMod.Artwork.Style;
						DBMod.RaidFrames.Style = DBMod.Artwork.Style;
						spartan:GetModule("Style_Classic"):SetupProfile();
						ReloadUI(); end
				},
				Transparent = {name = "Transparent", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Transparent", 120, 60 end,
					func = function() 
						DBMod.Artwork.Style = "Transparent";
						DBMod.PlayerFrames.Style = DBMod.Artwork.Style;
						DBMod.PartyFrames.Style = DBMod.Artwork.Style;
						DBMod.RaidFrames.Style = DBMod.Artwork.Style;
						spartan:GetModule("Style_Transparent"):SetupProfile();
						ReloadUI();
					end
				},
				Minimal = {name = "Minimal", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Minimal", 120, 60 end,
					func = function() 
						DBMod.Artwork.Style = "Minimal";
						DBMod.PlayerFrames.Style = DBMod.Artwork.Style;
						DBMod.PartyFrames.Style = DBMod.Artwork.Style;
						DBMod.RaidFrames.Style = DBMod.Artwork.Style;
						spartan:GetModule("Style_Minimal"):SetupProfile();
						ReloadUI();
					end
				}
			}},
			
			Artwork = {type="group",name=L["Artwork"],order=100,args = {
				Classic = {name = "Classic", type="execute",
					image=function() return "interface\\addons\\SpartanUI_Artwork\\Themes\\Classic\\Images\\base-center", 120, 60 end,
					func = function()
						DBMod.Artwork.Style = "Classic";
						spartan:GetModule("Style_Classic"):SetupProfile();
						ReloadUI(); end
				},
				Transparent = {name = "Transparent", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Transparent", 120, 60 end,
					func = function()
						DBMod.Artwork.Style = "Transparent";
						spartan:GetModule("Style_Transparent"):SetupProfile();
						ReloadUI();
					end
				},
				Minimal = {name = "Minimal", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Minimal", 120, 60 end,
					func = function()
						DBMod.Artwork.Style = "Minimal";
						spartan:GetModule("Style_Minimal"):SetupProfile();
						ReloadUI();
					end
				}
			}},
			
			PlayerFrames = {type="group",name=L["PlayerFrames"],order=100,args = {
				Classic = {name = "Classic", type="execute",
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_PlayerFrames", 120, 60 end,
					imageCoords=function() return {0,.5,.5,1} end,
					func = function()
						DBMod.PlayerFrames.Style = "Classic";
						ReloadUI(); end
				},
				Transparent = {name = "Transparent", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_PlayerFrames", 120, 60 end,
					imageCoords=function() return {.5,1,0,.5} end,
					func = function()
						DBMod.PlayerFrames.Style = "Transparent";
						ReloadUI();
					end
				},
				Minimal = {name = "Minimal", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_PlayerFrames", 120, 60 end,
					imageCoords=function() return {0,.5,0,.5} end,
					func = function()
						DBMod.PlayerFrames.Style = "Minimal";
						ReloadUI();
					end
				}
			}},
			
			PartyFrames = {type="group",name=L["PartyFrames"],order=200,args = {
				Classic = {name = "Classic", type="execute",
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_PlayerFrames", 120, 60 end,
					imageCoords=function() return {0,.5,.5,1} end,
					func = function()
						DBMod.PartyFrames.Style = "Classic";
						ReloadUI(); end
				},
				Transparent = {name = "Transparent", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_PlayerFrames", 120, 60 end,
					imageCoords=function() return {.5,1,0,.5} end,
					func = function()
						DBMod.PartyFrames.Style = "Transparent";
						ReloadUI();
					end
				},
				Minimal = {name = "Minimal", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Minimal_LargeFrame", 120, 60 end,
					-- imageCoords=function() return {0,.5,0,.5} end,
					func = function()
						DBMod.PartyFrames.Style = "Minimal";
						ReloadUI();
					end
				}
			}},
			
			RaidFrames = {type="group",name=L["RaidFrames"],order=300,args = {
				Classic = {name = "Classic", type="execute",
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_PlayerFrames", 120, 60 end,
					imageCoords=function() return {0,.5,.5,1} end,
					func = function()
						DBMod.RaidFrames.Style = "Classic";
						ReloadUI(); end
				},
				Transparent = {name = "Transparent", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Transparent_RaidFrame", 120, 60 end,
					imageCoords=function() return {.25,.75,.25,.75} end,
					func = function()
						DBMod.RaidFrames.Style = "Transparent";
						ReloadUI();
					end
				},
				Minimal = {name = "Minimal", type="execute",disabled=true,
					image=function() return "interface\\addons\\SpartanUI\\media\\Style_Minimal_SmallFrame", 120, 60 end,
					imageCoords=function() return {.25,.75,.25,.75} end,
					func = function()
						DBMod.RaidFrames.Style = "Minimal";
						ReloadUI();
					end
				}
			}},
			
		}
	};
	spartan.opt.args["General"].args["font"] = {name = L["FontSizeStyle"], type = "group",order = 200,
		args = {
			a = {name=L["GFontSet"],type="header"},
			b = {name = L["FontType"], type="select",
				values = {["SpartanUI"]="Cognosis",["SUI4"]="NotoSans",["SUI4cn"]="NotoSans (zhCN)",["FrizQuadrata"]="Friz Quadrata",["ArialNarrow"]="Arial Narrow",["Skurri"]="Skurri",["Morpheus"]="Morpheus"},
				get = function(info) return DB.font.Primary.Face; end,
				set = function(info,val) DB.font.Primary.Face = val; end
			},
			c = {name = L["FontStyle"], type="select",
				values = {["normal"]=L["normal"], ["monochrome"]=L["monochrome"], ["outline"]=L["outline"], ["thickoutline"]=L["thickoutline"]},
				get = function(info) return DB.font.Primary.Type; end,
				set = function(info,val) DB.font.Primary.Type = val; end
			},
			d = {name = L["AdjFontSize"], type="range",width="double",
				min=-3,max=3,step=1,
				get = function(info) return DB.font.Primary.Size; end,
				set = function(info,val) DB.font.Primary.Size = val; end
			},
			z = {name = L["AplyGlobal"].." "..L["AllSet"], type="execute",width="double",
				func = function()
					DB.font.Core.Face = DB.font.Primary.Face;
					DB.font.Core.Type = DB.font.Primary.Type;
					DB.font.Core.Size = DB.font.Primary.Size;
					DB.font.Player.Face = DB.font.Primary.Face;
					DB.font.Player.Type = DB.font.Primary.Type;
					DB.font.Player.Size = DB.font.Primary.Size;
					DB.font.Party.Face = DB.font.Primary.Face;
					DB.font.Party.Type = DB.font.Primary.Type;
					DB.font.Party.Size = DB.font.Primary.Size;
					DB.font.Raid.Face = DB.font.Primary.Face;
					DB.font.Raid.Type = DB.font.Primary.Type;
					DB.font.Raid.Size = DB.font.Primary.Size;
					spartan:FontRefresh("Core");
					spartan:FontRefresh("Player");
					spartan:FontRefresh("Party");
					spartan:FontRefresh("Raid");
				end
			},
		
			Core = {name = L["CoreSet"],type = "group",
				args = {
					CFace = {name = L["FontType"], type="select", order = 1,
						values = {["SpartanUI"]="SpartanUI",["FrizQuadrata"]="Friz Quadrata",["ArialNarrow"]="Arial Narrow",["Skurri"]="Skurri",["Morpheus"]="Morpheus"},
						get = function(info) return DB.font.Core.Face; end,
						set = function(info,val) DB.font.Core.Face = val; spartan:FontRefresh("Core") end
					},
					COutline = {name = L["FontStyle"], type="select", order = 2,
						values = {["normal"]=L["normal"], ["monochrome"]=L["monochrome"], ["outline"]=L["outline"], ["thickoutline"]=L["thickoutline"]},
						get = function(info) return DB.font.Core.Type; end,
						set = function(info,val) DB.font.Core.Type = val; spartan:FontRefresh("Core") end
					},
					CSize = {name = L["AdjFontSize"], type="range", order = 3,width="full",
						min=-3,max=3,step=1,
						get = function(info) return DB.font.Core.Size; end,
						set = function(info,val) DB.font.Core.Size = val; spartan:FontRefresh("Core") end
					}
				}
			},
			Player = {name = L["PlayerSet"],type = "group",
				disabled = function(info) if not spartan:GetModule("PlayerFrames", true) then return true end end,
				args = {
					PlFace = {name = L["FontType"], type="select", order = 1,
						values = {["SpartanUI"]="SpartanUI",["FrizQuadrata"]="Friz Quadrata",["ArialNarrow"]="Arial Narrow",["Skurri"]="Skurri",["Morpheus"]="Morpheus"},
						get = function(info) return DB.font.Player.Face; end,
						set = function(info,val) DB.font.Player.Face = val; spartan:FontRefresh("Player") end
					},
					PlOutline = {name = L["FontStyle"], type="select", order = 2,
						values = {["normal"]=L["normal"], ["monochrome"]=L["monochrome"], ["outline"]=L["outline"], ["thickoutline"]=L["thickoutline"]},
						get = function(info) return DB.font.Player.Type; end,
						set = function(info,val) DB.font.Player.Type = val; spartan:FontRefresh("Player") end
					},
					PlSize = {name = L["AdjFontSize"], type="range", order = 3,width="full",
						min=-3,max=3,step=1,
						get = function(info) return DB.font.Player.Size; end,
						set = function(info,val) DB.font.Player.Size = val; spartan:FontRefresh("Player") end
					}
				}
			},
			Party = {name = L["PartySet"],type = "group",
				disabled = function(info) if not spartan:GetModule("PartyFrames", true) then return true end end,
				args = {
					PaFace = {name = L["FontType"], type="select", order = 1,
						values = {["SpartanUI"]="SpartanUI",["FrizQuadrata"]="Friz Quadrata",["ArialNarrow"]="Arial Narrow",["Skurri"]="Skurri",["Morpheus"]="Morpheus"},
						get = function(info) return DB.font.Party.Face; end,
						set = function(info,val) DB.font.Party.Face = val; spartan:FontRefresh("Party") end
					},
					PaOutline = {name = L["FontStyle"], type="select", order = 2,
						values = {["normal"]=L["normal"], ["monochrome"]=L["monochrome"], ["outline"]=L["outline"], ["thickoutline"]=L["thickoutline"]},
						get = function(info) return DB.font.Party.Type; end,
						set = function(info,val) DB.font.Party.Type = val; spartan:FontRefresh("Party") end
					},
					PaSize = {name = L["AdjFontSize"], type="range", order = 3,width="full",
						min=-3,max=3,step=1,
						get = function(info) return DB.font.Party.Size; end,
						set = function(info,val) DB.font.Party.Size = val; spartan:FontRefresh("Party") end
					}
				}
			},
			raid = {name = L["RaidSet"],type = "group",
				disabled = function(info) if not spartan:GetModule("RaidFrames", true) then return true end end,
				args = {
					RFace = {name = L["FontType"], type="select", order = 1,
						values = {["SpartanUI"]="SpartanUI",["FrizQuadrata"]="Friz Quadrata",["ArialNarrow"]="Arial Narrow",["Skurri"]="Skurri",["Morpheus"]="Morpheus"},
						get = function(info) return DB.font.Raid.Face; end,
						set = function(info,val) DB.font.Raid.Face = val; spartan:FontRefresh("Raid") end
					},
					ROutline = {name = L["FontStyle"], type="select", order = 2,
						values = {["normal"]=L["normal"], ["monochrome"]=L["monochrome"], ["outline"]=L["outline"], ["thickoutline"]=L["thickoutline"]},
						get = function(info) return DB.font.Raid.Type; end,
						set = function(info,val) DB.font.Raid.Type = val; spartan:FontRefresh("Raid") end
					},
					RSize = {name = L["AdjFontSize"], type="range", order = 3,width="full",
						min=-3,max=3,step=1,
						get = function(info) return DB.font.Raid.Size; end,
						set = function(info,val) DB.font.Raid.Size = val; spartan:FontRefresh("Raid") end
					}
				}
			},
		}
	};
	spartan.opt.args["General"].args["Help"] = {name = "Help", type = "group", order = 900,
		args = {
			ResetDB			= {name = L["ResetDatabase"], type = "execute", order=1, func = function() spartan.db:ResetDB(); ReloadUI(); end},
			ResetArtwork	= {name = L["Reset ActionBars"], type = "execute", order=2, func = function() DBMod.Artwork.FirstLoad = true; spartan:GetModule("Style_"..DBMod.Artwork.Style):SetupProfile(); ReloadUI(); end},
			ResetMovedFrames	= {name = L["ResetMovableFrames"], type = "execute", order=3, func = function()
				local FramesList = {[1]="pet",[2]="target",[3]="targettarget",[4]="focus",[5]="focustarget",[6]="player",[7]="boss"}
				for a,b in pairs(FramesList) do
					DBMod.PlayerFrames[b].moved = false
				end
				DBMod.PartyFrames.moved = false
				DBMod.RaidFrames.moved = false
				spartan:GetModule("PlayerFrames"):UpdatePosition()
			end},
			
			line1 = {name="",type="header",order = 49},
			ver1 = {name="SUI Version: " .. spartan.SpartanVer,type="description",order = 50,fontSize="large"},
			ver2 = {name="SUI Build: " .. spartan.CurseVersion,type="description",order = 51,fontSize="large"},
			
			line2 = {name="",type="header",order = 99},
			navigationissues = {name=L["HaveQuestion"],type="description",order = 100,fontSize="large"},
			navigationissues2 = {name="    -|cff6666FF http://faq.spartanui.net/",type="description",order = 101,fontSize="medium"},
			
			bugsandfeatures = {name=L["Bugs and Feature Requests"] .. ":",type="description",order = 200,fontSize="large"},
			bugsandfeatures2 = {name="     -|cff6666FF http://bugs.spartanui.net/",type="description",order = 201,fontSize="medium"},
			
			
			line3 = {name="",type="header",order = 900},
			description = {name=L["HelpStringDesc1"],type="description",order = 901,fontSize="large"},
			description = {name=L["HelpStringDesc2"],type="description",order = 902,fontSize="small"},
			dataDump = {name=L["Export"],type="input",multiline=15,width="full",order=993,get = function(info) return module:enc(module:ExportData()) end},
			}
		}
	
	spartan.opt.args["General"].args["ModSetting"] = {name = L["Enabledmodules"], type = "group", order = 800,
		args = {
			description = {type="description",name=L["ModulesDesc"],order=1,fontSize="medium"},
			Artwork = {name = L["Artwork"],type = "toggle",order=10,
				get = function(info) return ModsLoaded.Artwork end,
				set = function(info,val)
					if ModsLoaded.Artwork then ModsLoaded.Artwork = false else ModsLoaded.Artwork = true end
					if ModsLoaded.Artwork then EnableAddOn("SpartanUI_Artwork") else DisableAddOn("SpartanUI_Artwork") end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			},
			PlayerFrames = {name = L["PlayerFrames"],type = "toggle",order=20,
				get = function(info) return ModsLoaded.PlayerFrames end,
				set = function(info,val)
					if ModsLoaded.PlayerFrames then ModsLoaded.PlayerFrames = false else ModsLoaded.PlayerFrames = true end
					if ModsLoaded.PlayerFrames then EnableAddOn("SpartanUI_PlayerFrames") else DisableAddOn("SpartanUI_PlayerFrames") end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			},
			PartyFrames = {name = L["PartyFrames"],type = "toggle",order=30,
				get = function(info) return ModsLoaded.PartyFrames end,
				set = function(info,val)
					if ModsLoaded.PartyFrames then ModsLoaded.PartyFrames = false else ModsLoaded.PartyFrames = true end
					if ModsLoaded.PartyFrames then EnableAddOn("SpartanUI_PartyFrames") else DisableAddOn("SpartanUI_PartyFrames") end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			},
			RaidFrames = {name = L["RaidFrames"],type = "toggle",order=40,
				get = function(info) return ModsLoaded.RaidFrames end,
				set = function(info,val)
					if ModsLoaded.RaidFrames then ModsLoaded.RaidFrames = false else ModsLoaded.RaidFrames = true end
					if ModsLoaded.RaidFrames then EnableAddOn("SpartanUI_RaidFrames") else DisableAddOn("SpartanUI_RaidFrames") end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			},
			SpinCam = {name = L["SpinCam"],type = "toggle",order=50,
				get = function(info) return ModsLoaded.SpinCam end,
				set = function(info,val)
					if ModsLoaded.SpinCam then ModsLoaded.SpinCam = false else ModsLoaded.SpinCam = true end
					if ModsLoaded.SpinCam then EnableAddOn("SpartanUI_SpinCam") else DisableAddOn("SpartanUI_SpinCam") end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			},
			FilmEffects = {name = L["FilmEffects"],type = "toggle",order=60,
				get = function(info) return ModsLoaded.FilmEffects end,
				set = function(info,val)
					if ModsLoaded.FilmEffects then ModsLoaded.FilmEffects = false else ModsLoaded.FilmEffects = true end
					if ModsLoaded.FilmEffects then EnableAddOn("SpartanUI_FilmEffects") else DisableAddOn("SpartanUI_FilmEffects") end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			},
			Styles = {name = L["Styles"],type = "group",order=100,inline=true,args={}},
			Components = {name = "Components",type = "group",order=200,inline=true,args={}},
			Reload = {name = "ReloadUI", type = "execute",order=200,disabled=true, func = function() spartan:reloadui(); end},
		}
	}

	-- List Styles
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled,loadable = GetAddOnInfo(i)
		ModsLoaded[name] = enabled
		if (string.match(name, "SpartanUI_Style_")) then
			spartan.opt.args["General"].args["ModSetting"].args["Styles"].args[string.sub(name, 9)] = {
				name = string.sub(name, 17),type = "toggle",
				get = function(info) return ModsLoaded[name] end,
				set = function(info,val)
					if ModsLoaded[name] then ModsLoaded[name] = false else ModsLoaded[name] = true end
					if ModsLoaded[name] then EnableAddOn(name) else DisableAddOn(name) end
					spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false;
				end,
			}
		end
	end

	-- List Components
	for name, submodule in spartan:IterateModules() do
		if (string.match(name, "Component_")) then
			local RealName = string.sub(name, 11)
			if DB.EnabledComponents == nil then DB.EnabledComponents = {} end
			if DB.EnabledComponents[RealName] == nil then
				DB.EnabledComponents[RealName] = true
			end
			
			spartan.opt.args["General"].args["ModSetting"].args["Components"].args[RealName] = {
				name = string.sub(name, 11),type = "toggle",
				get = function(info) return DB.EnabledComponents[RealName] end,
				set = function(info,val) DB.EnabledComponents[RealName] = val; spartan.opt.args["General"].args["ModSetting"].args["Reload"].disabled = false; end,
			}
			
		end
	end
end

function module:OnEnable()
	if not spartan:GetModule("Artwork_Core", true) then
		spartan.opt.args["General"].args["style"].args["OverallStyle"].disabled = true
	end
end

function module:ExportData()
	--Get Character Data
    local CharData = {
		Region = GetCurrentRegion(),
		class = UnitClass("player"),
		Faction = UnitFactionGroup("player"),
		-- PlayerName = UnitName("player"),
		PlayerLevel = UnitLevel("player"),
		ActiveSpec = GetSpecializationInfo(GetSpecialization()),
		Zone = GetRealZoneText() ..  " - " .. GetSubZoneText()
	}
	
	--Generate List of Addons
	local AddonsInstalled = {}
	
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled,loadable = GetAddOnInfo(i)
		if enabled == true then
			AddonsInstalled[i] = name
		end
	end
	
	return "$SUI." .. spartan.SpartanVer .. "-" .. spartan.CurseVersion
		.. "$C." .. module:FlatenTable(CharData)
		.. "$Artwork.Style." .. DBMod.Artwork.Style
		.. "$PlayerFrames.Style." .. DBMod.PlayerFrames.Style
		.. "$PartyFrames.Style." .. DBMod.PartyFrames.Style
		.. "$RaidFrames.Style." .. DBMod.RaidFrames.Style
		.. "$Addons." .. module:FlatenTable(AddonsInstalled)
		.. "..$END$.."
		-- .. "$DB." .. module:FlatenTable(DB)
		-- .. "$DBMod." .. module:FlatenTable(DBMod)
end

function module:FlatenTable(input)
	local returnval = ""
	for key,value in pairs(input) do
		if (type(value) == "table") then
			returnval = returnval .. key .. "= {" .. module:FlatenTable(value) .. "},"
		elseif (type(value) ~= "string") then
			returnval = returnval .. key .. "=" .. tostring(value) .. ","
		else
			returnval = returnval .. key .. "=" .. value .. ","
		end
	end
	return returnval
end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
-- encoding
function module:enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
 
-- decoding
function module:dec(data)

    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(7-i) or 0) end
        return string.char(c)
    end))
end
