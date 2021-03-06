local _G, SUI, L = _G, SUI, SUI.L
local module = SUI:NewModule('Component_AutoSell', 'AceTimer-3.0')
----------------------------------------------------------------------------------------------------
local frame = CreateFrame('FRAME')
local Tooltip = CreateFrame('GameTooltip', 'AutoSellTooltip', nil, 'GameTooltipTemplate')
local totalValue = 0
module.SellTimer = nil
local ExcludedItems = {
	137642, --Mark Of Honor
	141446, --Tome of the Tranquil Mind
	6219, -- Arclight Spanner
	140209, --imported blacksmith hammer
	5956, -- Blacksmith Hammer
	7005, --skinning knife
	2901, --mining pick
	81055 -- Darkmoon ride ticket
}

function module:OnInitialize()
	local Defaults = {
		FirstLaunch = true,
		NotCrafting = true,
		NotConsumables = true,
		NotInGearset = true,
		MaxILVL = 180,
		Gray = true,
		White = false,
		Green = false,
		Blue = false,
		Purple = false,
		GearTokens = false,
		AutoRepair = false,
		UseGuildBankRepair = false
	}
	if not SUI.DB.AutoSell then
		SUI.DB.AutoSell = Defaults
	else
		SUI.DB.AutoSell = SUI:MergeData(SUI.DB.AutoSell, Defaults, false)
	end
	if SUI.DB.AutoSell.MaxILVL >= 501 then
		SUI.DB.AutoSell.MaxILVL = 200
	end
end

local DummyFunction = function()
end

function module:FirstTime()
	local PageData = {
		ID = 'Autosell',
		Name = L['Auto sell'],
		SubTitle = L['Auto sell'],
		Desc1 = L['Automatically vendor items when you visit a merchant.'],
		Desc2 = L['Crafting, consumables, and gearset items will not be sold by default.'],
		RequireDisplay = SUI.DB.AutoSell.FirstLaunch,
		Display = function()
			local window = SUI:GetModule('SetupWizard').window
			local SUI_Win = window.content
			local StdUi = window.StdUi
			if not SUI.DB.EnabledComponents.AutoSell then
				window.Skip:Click()
			end

			--Container
			local AutoSell = CreateFrame('Frame', nil)
			AutoSell:SetParent(SUI_Win)
			AutoSell:SetAllPoints(SUI_Win)

			-- Quality Selling Options
			AutoSell.SellGray = StdUi:Checkbox(AutoSell, L['Sell gray'], 220, 20)
			AutoSell.SellWhite = StdUi:Checkbox(AutoSell, L['Sell white'], 220, 20)
			AutoSell.SellGreen = StdUi:Checkbox(AutoSell, L['Sell green'], 220, 20)
			AutoSell.SellBlue = StdUi:Checkbox(AutoSell, L['Sell blue'], 220, 20)
			AutoSell.SellPurple = StdUi:Checkbox(AutoSell, L['Sell purple'], 220, 20)

			-- Max iLVL
			AutoSell.iLVLDesc = StdUi:Label(AutoSell, L['Maximum iLVL to sell'], nil, nil, 350)
			AutoSell.iLVLLabel = StdUi:NumericBox(AutoSell, 80, 20, '180')
			AutoSell.iLVLLabel:SetMaxValue(500)
			AutoSell.iLVLLabel:SetMinValue(1)
			AutoSell.iLVLLabel.OnValueChanged = function()
				local win = SUI:GetModule('SetupWizard').window.content.AutoSell

				if math.floor(win.iLVLLabel:GetValue()) ~= math.floor(win.iLVLSlider:GetValue()) then
					win.iLVLSlider:SetValue(math.floor(win.iLVLLabel:GetValue()))
				end
			end

			AutoSell.iLVLSlider = StdUi:Slider(AutoSell, 500, 20, 180, false, 1, 500)
			AutoSell.iLVLSlider.OnValueChanged = function()
				local win = SUI:GetModule('SetupWizard').window.content.AutoSell

				if math.floor(win.iLVLLabel:GetValue()) ~= math.floor(win.iLVLSlider:GetValue()) then
					win.iLVLLabel:SetValue(math.floor(win.iLVLSlider:GetValue()))
				end
			end

			-- AutoRepair
			AutoSell.AutoRepair = StdUi:Checkbox(AutoSell, L['Auto repair'], 220, 20)

			-- Positioning
			StdUi:GlueTop(AutoSell.SellGray, SUI_Win, 0, -30)
			StdUi:GlueBelow(AutoSell.SellWhite, AutoSell.SellGray, 0, -5)
			StdUi:GlueBelow(AutoSell.SellGreen, AutoSell.SellWhite, 0, -5)
			StdUi:GlueBelow(AutoSell.SellBlue, AutoSell.SellGreen, 0, -5)
			StdUi:GlueBelow(AutoSell.SellPurple, AutoSell.SellBlue, 0, -5)
			StdUi:GlueBelow(AutoSell.iLVLDesc, AutoSell.SellPurple, 0, -5)
			StdUi:GlueBelow(AutoSell.iLVLSlider, AutoSell.iLVLDesc, -40, -5)
			StdUi:GlueRight(AutoSell.iLVLLabel, AutoSell.iLVLSlider, 2, 0)
			StdUi:GlueBelow(AutoSell.AutoRepair, AutoSell.iLVLSlider, 40, -5)

			-- Attaching
			SUI_Win.AutoSell = AutoSell

			-- Defaults
			AutoSell.SellGray:SetChecked(SUI.DB.AutoSell.Gray)
			AutoSell.SellWhite:SetChecked(SUI.DB.AutoSell.White)
			AutoSell.SellGreen:SetChecked(SUI.DB.AutoSell.Green)
			AutoSell.SellBlue:SetChecked(SUI.DB.AutoSell.Blue)
			AutoSell.SellPurple:SetChecked(SUI.DB.AutoSell.Purple)
			AutoSell.AutoRepair:SetChecked(SUI.DB.AutoSell.AutoRepair)
			AutoSell.iLVLLabel:SetValue(SUI.DB.AutoSell.MaxILVL)
		end,
		Next = function()
			local SUI_Win = SUI:GetModule('SetupWizard').window.content.AutoSell

			SUI.DB.AutoSell.Gray = (SUI_Win.SellGray:GetChecked() == true or false)
			SUI.DB.AutoSell.White = (SUI_Win.SellWhite:GetChecked() == true or false)
			SUI.DB.AutoSell.Green = (SUI_Win.SellGreen:GetChecked() == true or false)
			SUI.DB.AutoSell.Blue = (SUI_Win.SellBlue:GetChecked() == true or false)
			SUI.DB.AutoSell.Purple = (SUI_Win.SellPurple:GetChecked() == true or false)
			SUI.DB.AutoSell.AutoRepair = (SUI_Win.AutoRepair:GetChecked() == true or false)
			SUI.DB.AutoSell.MaxILVL = SUI_Win.iLVLLabel:GetValue()

			SUI.DB.AutoSell.FirstLaunch = false
		end,
		Skip = function()
			SUI.DB.AutoSell.FirstLaunch = false
		end
	}
	local SetupWindow = SUI:GetModule('SetupWizard')
	SetupWindow:AddPage(PageData)
end

local IsInGearset = function(bag, slot)
	local line
	Tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	Tooltip:SetBagItem(bag, slot)

	for i = 1, Tooltip:NumLines() do
		line = _G['AutoSellTooltipTextLeft' .. i]
		if line:GetText():find(EQUIPMENT_SETS:format('.*')) then
			return true
		end
	end

	return false
end

function module:IsSellable(item, ilink, bag, slot)
	if not item then
		return false
	end
	local name,
		_,
		quality,
		iLevel,
		_,
		itemType,
		itemSubType,
		_,
		equipSlot,
		_,
		vendorPrice,
		_,
		_,
		_,
		_,
		_,
		isCraftingReagent = GetItemInfo(ilink)
	if vendorPrice == 0 or name == nil then
		return false
	end

	-- 0. Poor (gray): Broken I.W.I.N. Button
	-- 1. Common (white): Archmage Vargoth's Staff
	-- 2. Uncommon (green): X-52 Rocket Helmet
	-- 3. Rare / Superior (blue): Onyxia Scale Cloak
	-- 4. Epic (purple): Talisman of Ephemeral Power
	-- 5. Legendary (orange): Fragment of Val'anyr
	-- 6. Artifact (golden yellow): The Twin Blades of Azzinoth
	-- 7. Heirloom (light yellow): Bloodied Arcanite Reaper
	local ilvlsellable = false
	local qualitysellable = false
	local Craftablesellable = false
	local NotInGearset = true
	local NotConsumable = true
	local IsGearToken = false

	if quality == 0 and SUI.DB.AutoSell.Gray then
		qualitysellable = true
	end
	if quality == 1 and SUI.DB.AutoSell.White then
		qualitysellable = true
	end
	if quality == 2 and SUI.DB.AutoSell.Green then
		qualitysellable = true
	end
	if quality == 3 and SUI.DB.AutoSell.Blue then
		qualitysellable = true
	end
	if quality == 4 and SUI.DB.AutoSell.Purple then
		qualitysellable = true
	end

	if (not iLevel) or (iLevel <= SUI.DB.AutoSell.MaxILVL) then
		ilvlsellable = true
	end
	--Crafting Items
	if
		((itemType == 'Gem' or itemType == 'Reagent' or itemType == 'Trade Goods' or itemType == 'Tradeskill') or
			(itemType == 'Miscellaneous' and itemSubType == 'Reagent')) or
			(itemType == 'Item Enhancement') or
			isCraftingReagent
	 then
		if not SUI.DB.AutoSell.NotCrafting then
			Craftablesellable = true
		end
	else
		Craftablesellable = true
	end

	--Gearset detection
	if C_EquipmentSet.CanUseEquipmentSets() and IsInGearset(bag, slot) then
		NotInGearset = false
	end

	--Consumable
	--Tome of the Tranquil Mind is consumable but is identified as Other.
	if SUI.DB.AutoSell.NotConsumables and itemType == 'Consumable' then
		NotConsumable = false
	end

	-- Gear Tokens
	if
		quality == 4 and itemType == 'Miscellaneous' and itemSubType == 'Junk' and equipSlot == '' and
			not SUI.DB.AutoSell.GearTokens
	 then
		IsGearToken = true
	end

	if string.find(name, 'Treasure Map') and quality == 1 then
		qualitysellable = false
	end

	if
		qualitysellable and ilvlsellable and Craftablesellable and NotInGearset and NotConsumable and not IsGearToken and
			not SUI:isInTable(ExcludedItems, item) and
			itemType ~= 'Quest' and
			itemType ~= 'Container' or
			(quality == 0 and SUI.DB.AutoSell.Gray)
	 then --Legion identified some junk as consumable
		if SUI.DB.AutoSell.debug then
			SUI:Print('--Selling--')
			SUI:Print(item)
			SUI:Print(name)
			SUI:Print(ilink)
			SUI:Print('ilvl:     ' .. iLevel)
			SUI:Print('type:     ' .. itemType)
			SUI:Print('sub type: ' .. itemSubType)
		end
		return true
	end

	return false
end

function module:SellTrash()
	--Reset Locals
	totalValue = 0
	-- ItemsToSellTotal = 0
	local ItemToSell = {}

	--Find Items to sell
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local _, _, _, _, _, _, link, _, _, itemID = GetContainerItemInfo(bag, slot)
			if module:IsSellable(itemID, link, bag, slot) then
				ItemToSell[#ItemToSell + 1] = {bag, slot}
				-- ItemsToSellTotal = ItemsToSellTotal + 1
				totalValue = totalValue + (select(11, GetItemInfo(itemID)) * select(2, GetContainerItemInfo(bag, slot)))
			end
		end
	end

	--Sell Items if needed
	if #ItemToSell == 0 then
		SUI:Print(L['No items are to be auto sold'])
	else
		SUI:Print('Need to sell ' .. #ItemToSell .. ' item(s) for ' .. SUI:GoldFormattedValue(totalValue))
		--Start Loop to sell, reset locals
		module.SellTimer = module:ScheduleRepeatingTimer('SellTrashInBag', .2, ItemToSell)
	end
end

-- Sell Items 5 at a time, sometimes it can sell stuff too fast for the game.
function module:SellTrashInBag(ItemListing)
	-- Grab an item to sell
	local item = table.remove(ItemListing)

	-- If the Table is empty then exit.
	if (not item) then
		module:CancelAllTimers()
		return
	end

	-- SELL!
	UseContainerItem(item[1], item[2])

	-- If it was the last item stop timers
	if (#ItemListing == 0) then
		module:CancelAllTimers()
	end
end

function module:Repair()
	-- First see if this vendor can repair
	if (CanMerchantRepair() and SUI.DB.AutoSell.AutoRepair) then
		SUI:Print(L['Auto repairing if needed'])
		-- Use guild repair
		if (CanGuildBankRepair() == 1 and SUI.DB.AutoSell.UseGuildBankRepair) then
			RepairAllItems(1)
		end
		-- Use self repair
		RepairAllItems()
	end
end

function module:OnEnable()
	module:FirstTime()
	module:BuildOptions()
	if SUI.DB.EnabledComponents.AutoSell then
		module:Enable()
	else
		return
	end
end

function module:Enable()
	local function MerchantEventHandler(self, event, ...)
		if not SUI.DB.EnabledComponents.AutoSell then
			return
		end
		if event == 'MERCHANT_SHOW' then
			-- Sell then repair so we gain gold before we use it.
			module:ScheduleTimer('SellTrash', .2)
			-- module:SellTrash()
			module:Repair()
		else
			module:CancelAllTimers()
			if (totalValue > 0) then
				-- SUI:Print("Sold items for " .. SUI:GoldFormattedValue(totalValue));
				totalValue = 0
			end
		end
	end
	frame:SetScript('OnEvent', MerchantEventHandler)
	frame:RegisterEvent('MERCHANT_SHOW')
	frame:RegisterEvent('MERCHANT_CLOSED')
end

function module:Disable()
	SUI:Print('Autosell disabled')
	frame:UnregisterEvent('MERCHANT_SHOW')
	frame:UnregisterEvent('MERCHANT_CLOSED')
end

function module:BuildOptions()
	SUI.opt.args['ModSetting'].args['AutoSell'] = {
		type = 'group',
		name = L['Auto sell'],
		args = {
			NotCrafting = {
				name = L["Don't sell crafting items"],
				type = 'toggle',
				order = 1,
				width = 'full',
				get = function(info)
					return SUI.DB.AutoSell.NotCrafting
				end,
				set = function(info, val)
					SUI.DB.AutoSell.NotCrafting = val
				end
			},
			NotConsumables = {
				name = L["Don't sell consumables"],
				type = 'toggle',
				order = 2,
				width = 'full',
				get = function(info)
					return SUI.DB.AutoSell.NotConsumables
				end,
				set = function(info, val)
					SUI.DB.AutoSell.NotConsumables = val
				end
			},
			NotInGearset = {
				name = L["Don't sell items in a equipment set"],
				type = 'toggle',
				order = 3,
				width = 'full',
				get = function(info)
					return SUI.DB.AutoSell.NotInGearset
				end,
				set = function(info, val)
					SUI.DB.AutoSell.NotInGearset = val
				end
			},
			GearTokens = {
				name = L['Sell tier tokens'],
				type = 'toggle',
				order = 4,
				width = 'full',
				get = function(info)
					return SUI.DB.AutoSell.GearTokens
				end,
				set = function(info, val)
					SUI.DB.AutoSell.GearTokens = val
				end
			},
			MaxILVL = {
				name = L['Maximum iLVL to sell'],
				type = 'range',
				order = 10,
				width = 'full',
				min = 1,
				max = 500,
				step = 1,
				set = function(info, val)
					SUI.DB.AutoSell.MaxILVL = val
				end,
				get = function(info)
					return SUI.DB.AutoSell.MaxILVL
				end
			},
			Gray = {
				name = L['Sell gray'],
				type = 'toggle',
				order = 20,
				width = 'double',
				get = function(info)
					return SUI.DB.AutoSell.Gray
				end,
				set = function(info, val)
					SUI.DB.AutoSell.Gray = val
				end
			},
			White = {
				name = L['Sell white'],
				type = 'toggle',
				order = 21,
				width = 'double',
				get = function(info)
					return SUI.DB.AutoSell.White
				end,
				set = function(info, val)
					SUI.DB.AutoSell.White = val
				end
			},
			Green = {
				name = L['Sell green'],
				type = 'toggle',
				order = 22,
				width = 'double',
				get = function(info)
					return SUI.DB.AutoSell.Green
				end,
				set = function(info, val)
					SUI.DB.AutoSell.Green = val
				end
			},
			Blue = {
				name = L['Sell blue'],
				type = 'toggle',
				order = 23,
				width = 'double',
				get = function(info)
					return SUI.DB.AutoSell.Blue
				end,
				set = function(info, val)
					SUI.DB.AutoSell.Blue = val
				end
			},
			Purple = {
				name = L['Sell purple'],
				type = 'toggle',
				order = 24,
				width = 'double',
				get = function(info)
					return SUI.DB.AutoSell.Purple
				end,
				set = function(info, val)
					SUI.DB.AutoSell.Purple = val
				end
			},
			line1 = {name = '', type = 'header', order = 200},
			AutoRepair = {
				name = L['Auto repair'],
				type = 'toggle',
				order = 201,
				get = function(info)
					return SUI.DB.AutoSell.AutoRepair
				end,
				set = function(info, val)
					SUI.DB.AutoSell.AutoRepair = val
				end
			},
			UseGuildBankRepair = {
				name = L['Use guild bank repair if possible'],
				type = 'toggle',
				order = 202,
				get = function(info)
					return SUI.DB.AutoSell.UseGuildBankRepair
				end,
				set = function(info, val)
					SUI.DB.AutoSell.UseGuildBankRepair = val
				end
			},
			line2 = {name = '', type = 'header', order = 600},
			debug = {
				name = L['Enable debug messages'],
				type = 'toggle',
				order = 601,
				width = 'full',
				get = function(info)
					return SUI.DB.AutoSell.debug
				end,
				set = function(info, val)
					SUI.DB.AutoSell.debug = val
				end
			}
		}
	}
end
