local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI");
local L = LibStub("AceLocale-3.0"):GetLocale("SpartanUI", true);
local Artwork_Core = spartan:GetModule("Artwork_Core");
local module = spartan:GetModule("Style_Transparent");
----------------------------------------------------------------------------------------------------
local InitRan = false
function module:OnInitialize()
	--Enable the in the Core options screen
	spartan.opt.args["General"].args["style"].args["OverallStyle"].args["Transparent"].disabled = false
	spartan.opt.args["General"].args["style"].args["Artwork"].args["Transparent"].disabled = false
	spartan.opt.args["General"].args["style"].args["PlayerFrames"].args["Transparent"].disabled = false
	spartan.opt.args["General"].args["style"].args["PartyFrames"].args["Transparent"].disabled = false
	spartan.opt.args["General"].args["style"].args["RaidFrames"].args["Transparent"].disabled = false
	--Init if needed
	if (DBMod.Artwork.Style == "Transparent") then
		module:Init()
	end
end

function module:Init()
	if (DBMod.Artwork.FirstLoad) then module:FirstLoad() end
	module:SetupMenus();
	module:InitFramework();
	module:InitActionBars();
	module:InitMinimap();
	module:InitStatusBars();
	InitRan = true;
end

function module:FirstLoad()
	--If our profile exists activate it.
	if ((Bartender4.db:GetCurrentProfile() ~= DB.Styles.Transparent.BartenderProfile) and not Artwork_Core:BartenderProfileCheck(DB.Styles.Transparent.BartenderProfile,true)) then Bartender4.db:SetProfile(DB.Styles.Transparent.BartenderProfile); end
end

function module:OnEnable()
	if (DBMod.Artwork.Style ~= "Transparent") then module:Disable(); return end
	if (DBMod.Artwork.Style == "Transparent") then
		if (not InitRan) then module:Init(); end
		if (not Artwork_Core:BartenderProfileCheck(DB.Styles.Transparent.BartenderProfile,true)) then module:CreateProfile(); end
		module:EnableFramework();
		module:EnableActionBars();
		module:EnableMinimap();
		module:EnableStatusBars();
		if (DBMod.Artwork.FirstLoad) then DBMod.Artwork.FirstLoad = false end -- We want to do this last
	end
end

function module:SetupMenus()
	spartan.opt.args["Artwork"].args["XPBar"] = {
		name = L["BarXP"],
		desc = L["BarXPDesc"],
		type = "group", args = {
			display = {name=L["BarXPEnabled"],type="toggle",order=.1,
				get = function(info) return DB.StatusBars.XPBar.enabled; end,
				set = function(info,val) DB.StatusBars.XPBar.enabled = val; if DB.StatusBars.XPBar.enabled and not xpframe:IsVisible() then xpframe:Show(); elseif not DB.StatusBars.XPBar.enabled then xpframe:Hide(); end end
			},
			displaytext = {name=L["DisplayText"],type="toggle",order=.15,
				get = function(info) return DB.StatusBars.XPBar.text; end,
				set = function(info,val) DB.StatusBars.XPBar.text = val; module:SetXPColors(); end
			},
			tooltip = {name=L["DisplayTooltip"],type="select",order=.2,
				values = {["hover"]="Mouse Over",["click"]="On Click",["off"]="Disabled"},
				get = function(info) return DB.StatusBars.XPBar.ToolTip; end,
				set = function(info,val) DB.StatusBars.XPBar.ToolTip = val; end
			},
			header1 = {name=L["ClrGained"],type="header",order=.9},
			GainedColor = {name=L["GainedColor"],type="select",style="dropdown",order=1,width="full",
				values = {
					["Custom"]	= "Custom",
					["Orange"]	= "Orange",
					["Yellow"]	= "Yellow",
					["Green"]	= "Green",
					["Pink"]	= "Pink",
					["Purple"]	= "Purple",
					["Blue"]	= "Blue",
					["Red"]	= "Red",
					["Light_Blue"]	= "Light Blue",
				},
				get = function(info) return DB.StatusBars.XPBar.GainedColor; end,
				set = function(info,val) DB.StatusBars.XPBar.GainedColor = val; module:SetXPColors(); end
			},
			GainedRed = {name=L["Red"],type="range",order=2,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.GainedRed*100); end,
				set = function(info,val)
					if (DB.StatusBars.XPBar.GainedColor ~= "Custom") then DB.StatusBars.XPBar.GainedColor = "Custom"; end DB.StatusBars.XPBar.GainedRed = (val/100); module:SetXPColors();
				end
			},
			GainedGreen = {name=L["Green"],type="range",order=3,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.GainedGreen*100); end,
				set = function(info,val)
					if (DB.StatusBars.XPBar.GainedColor ~= "Custom") then DB.StatusBars.XPBar.GainedColor = "Custom"; end DB.StatusBars.XPBar.GainedGreen = (val/100);  module:SetXPColors();
				end
			},
			GainedBlue = {name=L["Blue"],type="range",order=4,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.GainedBlue*100); end,
				set = function(info,val)
					if (DB.StatusBars.XPBar.GainedColor ~= "Custom") then DB.StatusBars.XPBar.GainedColor = "Custom"; end DB.StatusBars.XPBar.GainedBlue = (val/100); module:SetXPColors();
				end
			},
			GainedBrightness = {name=L["Brightness"],type="range",order=5,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.GainedBrightness*100); end,
				set = function(info,val) if (DB.StatusBars.XPBar.GainedColor ~= "Custom") then DB.StatusBars.XPBar.GainedColor = "Custom"; end DB.StatusBars.XPBar.GainedBrightness = (val/100); module:SetXPColors(); end
			},
			header2 = {name=L["ClrRested"],type="header",order=10},
			RestedColor = {name=L["RestedColor"],type="select",style="dropdown",order=11,width="full",
				values = {
					["Custom"]	= "Custom",
					["Orange"]	= "Orange",
					["Yellow"]	= "Yellow",
					["Green"]	= "Green",
					["Pink"]	= "Pink",
					["Purple"]	= "Purple",
					["Blue"]	= "Blue",
					["Red"]	= "Red",
					["Light_Blue"]	= "Light Blue",
				},
				get = function(info) return DB.StatusBars.XPBar.RestedColor; end,
				set = function(info,val) DB.StatusBars.XPBar.RestedColor = val; module:SetXPColors(); end
			},
			RestedRed = {name=L["Red"],type="range",order=12,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.RestedRed*100); end,
				set = function(info,val)
					if (DB.StatusBars.XPBar.RestedColor ~= "Custom") then DB.StatusBars.XPBar.RestedColor = "Custom"; end DB.StatusBars.XPBar.RestedRed = (val/100); module:SetXPColors();
				end
			},
			RestedGreen = {name=L["Green"],type="range",order=13,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.RestedGreen*100); end,
				set = function(info,val)
					if (DB.StatusBars.XPBar.RestedColor ~= "Custom") then DB.StatusBars.XPBar.RestedColor = "Custom"; end DB.StatusBars.XPBar.RestedGreen = (val/100); module:SetXPColors();
				end
			},
			RestedBlue = {name=L["Blue"],type="range",order=14,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.RestedBlue*100); end,
				set = function(info,val)
					if (DB.StatusBars.XPBar.RestedColor ~= "Custom") then DB.StatusBars.XPBar.RestedColor = "Custom"; end DB.StatusBars.XPBar.RestedBlue = (val/100); module:SetXPColors();
				end
			},
			RestedBrightness = {name=L["Brightness"],type="range",order=15,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.XPBar.RestedBrightness*100); end,
				set = function(info,val) if (DB.StatusBars.XPBar.RestedColor ~= "Custom") then DB.StatusBars.XPBar.RestedColor = "Custom"; end DB.StatusBars.XPBar.RestedBrightness = (val/100); module:SetXPColors(); end
			},
			RestedMatchColor = {name=L["MatchRestedClr"],type="toggle",order=21,
				get = function(info) return DB.StatusBars.XPBar.RestedMatchColor; end,
				set = function(info,val) DB.StatusBars.XPBar.RestedMatchColor = val; module:SetXPColors(); end
			}
		}
	}
	spartan.opt.args["Artwork"].args["RepBar"] = {
		name = L["BarRep"],
		desc = L["BarRepDesc"],
		type = "group", args = {
			display = {name=L["BarRepEnabled"],type="toggle",order=.1,
				get = function(info) return DB.StatusBars.RepBar.enabled; end,
				set = function(info,val) DB.StatusBars.RepBar.enabled = val; if DB.StatusBars.RepBar.enabled and not repframe:IsVisible() then repframe:Show(); elseif not DB.StatusBars.RepBar.enabled then repframe:Hide(); end end
			},
			displaytext = {name=L["DisplayText"],type="toggle",order=.15,
				get = function(info) return DB.StatusBars.RepBar.text; end,
				set = function(info,val) DB.StatusBars.RepBar.text = val; module:SetRepColors(); end
			},
			tooltip = {name=L["DisplayTooltip"],type="select",order=.2,
				values = {["hover"]="Mouse Over",["click"]="On Click",["off"]="Disabled"},
				get = function(info) return DB.StatusBars.RepBar.ToolTip; end,
				set = function(info,val) DB.StatusBars.RepBar.ToolTip = val; end
			},
			header1 = {name=L["ClrRep"],type="header",order=.9},
			AutoDefined = {name=L["AutoRepClr"],type="toggle",order=1,desc=L["AutoRepClrDesc"],
			width="full",
				get = function(info) return DB.StatusBars.RepBar.AutoDefined; end,
				set = function(info,val) DB.StatusBars.RepBar.AutoDefined = val; module:SetRepColors(); end
			},
			RepColor = {name=L["Color"],type="select",style="dropdown",order=2,width="full",
				values = {
					["AUTO"]	= L["AUTO"],
					["Custom"]	= L["Custom"],
					["Orange"]	= L["Orange"],
					["Yellow"]	= L["Yellow"],
					["Green"]	= L["Green"],
					["Pink"]	= L["Pink"],
					["Purple"]	= L["Purple"],
					["Blue"]	= L["Blue"],
					["Red"]	= L["Red"],
					["Light_Blue"]	= L["LightBlue"],
				},
				get = function(info) return DB.StatusBars.RepBar.GainedColor; end,
				set = function(info,val) DB.StatusBars.RepBar.GainedColor = val; if val == "AUTO" then DB.StatusBars.RepBar.AutoDefined = true end module:SetRepColors(); end
			},
			RepRed = {name=L["Red"],type="range",order=3,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.RepBar.GainedRed*100); end,
				set = function(info,val)
					if (DB.StatusBars.RepBar.AutoDefined) then return end if (DB.StatusBars.RepBar.GainedColor ~= "Custom") then DB.StatusBars.RepBar.GainedColor = "Custom"; end DB.StatusBars.RepBar.GainedRed = (val/100); module:SetRepColors();
				end
			},
			RepGreen = {name=L["Green"],type="range",order=4,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.RepBar.GainedGreen*100); end,
				set = function(info,val)
					if (DB.StatusBars.RepBar.AutoDefined) then return end if (DB.StatusBars.RepBar.GainedColor ~= "Custom") then DB.StatusBars.RepBar.GainedColor = "Custom"; end DB.StatusBars.RepBar.GainedGreen = (val/100);  module:SetRepColors();
				end
			},
			RepBlue = {name=L["Blue"],type="range",order=5,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.RepBar.GainedBlue*100); end,
				set = function(info,val)
					if (DB.StatusBars.RepBar.AutoDefined) then return end if (DB.StatusBars.RepBar.GainedColor ~= "Custom") then DB.StatusBars.RepBar.GainedColor = "Custom"; end DB.StatusBars.RepBar.GainedBlue = (val/100); module:SetRepColors();
				end
			},
			RepBrightness = {name=L["Brightness"],type="range",order=6,
				min=0,max=100,step=1,
				get = function(info) return (DB.StatusBars.RepBar.GainedBrightness*100); end,
				set = function(info,val) if (DB.StatusBars.RepBar.AutoDefined) then return end if (DB.StatusBars.RepBar.GainedColor ~= "Custom") then DB.StatusBars.RepBar.GainedColor = "Custom"; end DB.StatusBars.RepBar.GainedBrightness = (val/100); module:SetRepColors(); end
			}
		}
	}
	spartan.opt.args["Artwork"].args["Artwork"] = {name = "Artwork Options",type="group",order=10,
		args = {
			alpha = {name=L["Transparency"],type="range",order=1,width="full",
				min=0,max=100,step=1,desc=L["TransparencyDesc"],
				get = function(info) return (DB.alpha*100); end,
				set = function(info,val) DB.alpha = (val/100); module:updateAlpha(); end
			},
			xOffset = {name = L["MoveSideways"],type = "range",order = 3,width="full",
				desc = L["MoveSidewaysDesc"],
				min=-200,max=200,step=.1,
				get = function(info) return DB.xOffset/6.25 end,
				set = function(info,val) DB.xOffset = val*6.25; module:updateXOffset(); end,
			},
			Color = {name=L["ArtColor"],type="color",hasAlpha=true,order=1,width="full",
				get = function(info) return unpack(DB.Styles.Transparent.Color.Art) end,
				set = function(info,r,b,g,a) DB.Styles.Transparent.Color.Art = {r,b,g,a}; module:SetColor(); end
			}
		}
	}
end

function module:OnDisable()
	Transparent_SpartanUI:Hide();
end
