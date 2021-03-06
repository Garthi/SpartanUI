local SUI, L = SUI, SUI.L
local module = SUI:NewModule('SetupWizard')
local StdUi = LibStub('StdUi'):NewInstance()
module.window = nil

local DisplayRequired, InitDone, ReloadNeeded = false, false, false
local TotalPageCount, PageDisplayOrder, PageDisplayed = 0, 1, 0
local PriorityPageList, StandardPageList, FinalPageList, PageID, CurrentDisplay = {}, {}, {}, {}, {}
local ReloadPage = {
	ID = 'ReloadPage',
	Name = 'Reload required',
	SubTitle = 'Reload required',
	Desc1 = 'Setup finished!',
	Desc2 = 'This completes the setup wizard, a reload of the UI is required to finish the setup.',
	Display = function()
		module.window.content.WelcomePage = CreateFrame('Frame', nil)
		module.window.content.WelcomePage:SetParent(module.window.content)
		module.window.content.WelcomePage:SetAllPoints(module.window.content)

		module.window.content.WelcomePage.Helm =
			StdUi:Texture(module.window.content.WelcomePage, 150, 150, 'Interface\\AddOns\\SpartanUI\\media\\Spartan-Helm')
		module.window.content.WelcomePage.Helm:SetPoint('CENTER')
		module.window.content.WelcomePage.Helm:SetAlpha(.6)

		module.window.Next:SetText('RELOAD UI')
	end,
	Next = function()
		ReloadUI()
	end
}

local LoadWatcherEvent = function()
	module:ShowWizard()
end

function module:AddPage(PageData)
	-- Make sure SetupWizard does it's initalization before any pages other are added
	if not InitDone then
		module:OnInitialize()
	end

	-- Incriment the page count/id by 1
	TotalPageCount = TotalPageCount + 1

	-- Store the Page's Data in a local table for latter
	-- If the page is flagged as priorty then we want it at the top of the list.
	if PageData.Priority then
		PriorityPageList[PageData.ID] = PageData
	else
		StandardPageList[PageData.ID] = PageData
	end
	if PageData.RequireDisplay then
		DisplayRequired = true
	end

	-- Track the Pages defined ID to the generated ID, this allows us to display pages in the order they were added to the system
	PageID[TotalPageCount] = {
		ID = PageData.ID,
		DisplayOrder = nil
	}
end

function module:FindNextPage()
	-- First make sure our Display Order is up to date
	-- First add any priority pages
	for i = 1, TotalPageCount do
		local key = PageID[i]

		if PriorityPageList[key.ID] and key.DisplayOrder == nil then
			FinalPageList[PageDisplayOrder] = key.ID
			PageID[i][PageDisplayOrder] = PageDisplayOrder
			PageDisplayOrder = PageDisplayOrder + 1
		end
	end

	-- Now add Standard Pages
	for i = 1, TotalPageCount do
		local key = PageID[i]

		if StandardPageList[key.ID] and key.DisplayOrder == nil then
			FinalPageList[PageDisplayOrder] = key.ID
			PageID[i][PageDisplayOrder] = PageDisplayOrder
			PageDisplayOrder = PageDisplayOrder + 1
		end
	end
	module.window.ProgressBar:SetMinMaxValues(1, 100)

	--Find the next undisplayed page
	if ReloadNeeded and PageDisplayed == TotalPageCount then
		PageDisplayed = PageDisplayed + 1
		module.window.Status:Hide()
		module:DisplayPage(ReloadPage)
	elseif not ReloadNeeded and PageDisplayed == TotalPageCount then
		module.window:Hide()
		module.window = nil
	elseif FinalPageList[(PageDisplayed + 1)] then
		PageDisplayed = PageDisplayed + 1
		local ID = FinalPageList[PageDisplayed]

		-- Find what kind of page this is
		if PriorityPageList[ID] then
			module:DisplayPage(PriorityPageList[ID])
		elseif StandardPageList[ID] then
			module:DisplayPage(StandardPageList[ID])
		end
	end
end

function module:DisplayPage(PageData)
	CurrentDisplay = PageData
	if PageData.title then
		module.window.titleHolder:SetText(PageData.title)
	end
	if PageData.SubTitle then
		module.window.SubTitle:SetText(PageData.SubTitle)
	else
		module.window.SubTitle:SetText('')
	end
	if PageData.Desc1 then
		module.window.Desc1:SetText(PageData.Desc1)
	else
		module.window.Desc1:SetText('')
	end
	if PageData.Desc2 then
		module.window.Desc2:SetText(PageData.Desc2)
	else
		module.window.Desc2:SetText('')
	end
	if PageData.Display then
		PageData.Display()
	end
	if PageData.Skip ~= nil then
		module.window.Skip:Show()
	else
		module.window.Skip:Hide()
	end

	-- Update the Status Counter & Progress Bar
	module.window.Status:SetText(PageDisplayed .. ' /  ' .. TotalPageCount)
	if module.window.ProgressBar then
		if PageDisplayed > TotalPageCount then
			module.window.ProgressBar:SetValue(100)
		else
			module.window.ProgressBar:SetValue((100 / TotalPageCount) * (PageDisplayed - 1))
		end
	end
end

function module:ShowWizard()
	module.window = StdUi:Window(nil, 'SpartanUI setup wizard', 650, 500)
	module.window.StdUi = StdUi
	module.window:SetPoint('CENTER', 0, 0)
	module.window:SetFrameStrata('DIALOG')

	-- Setup the Top text fields
	module.window.SubTitle = StdUi:Label(module.window, '', 16, nil, module.window:GetWidth(), 20)
	module.window.SubTitle:SetPoint('TOP', module.window.titlePanel, 'BOTTOM', 0, -5)
	module.window.SubTitle:SetTextColor(.29, .18, .96, 1)
	module.window.SubTitle:SetJustifyH('CENTER')

	module.window.Desc1 = StdUi:Label(module.window, '', 13, nil, module.window:GetWidth())
	-- module.window.Desc1 = module.window:CreateFontString(nil, 'OVERLAY', 'SUI_FontOutline13')
	module.window.Desc1:SetPoint('TOP', module.window.SubTitle, 'BOTTOM', 0, -5)
	module.window.Desc1:SetTextColor(1, 1, 1, .8)
	module.window.Desc1:SetWidth(module.window:GetWidth() - 40)
	module.window.Desc1:SetJustifyH('CENTER')

	module.window.Desc2 = StdUi:Label(module.window, '', 13, nil, module.window:GetWidth())
	-- module.window.Desc2 = module.window:CreateFontString(nil, 'OVERLAY', 'SUI_FontOutline13')
	module.window.Desc2:SetPoint('TOP', module.window.Desc1, 'BOTTOM', 0, -3)
	module.window.Desc2:SetTextColor(1, 1, 1, .8)
	module.window.Desc2:SetWidth(module.window:GetWidth() - 40)
	module.window.Desc2:SetJustifyH('CENTER')

	module.window.Status = StdUi:Label(module.window, '', 9, nil, 40, 15)
	module.window.Status:SetPoint('TOPRIGHT', module.window, 'TOPRIGHT', -2, -2)

	-- Setup the Buttons
	module.window.Skip = StdUi:Button(module.window, 150, 20, 'SKIP')
	module.window.Next = StdUi:Button(module.window, 150, 20, 'CONTINUE')

	-- If we have more than one page to show then add a progress bar, and a selection tree on the side.
	if TotalPageCount > 1 then
		-- Add a Progress bar to the bottom
		local ProgressBar = StdUi:ProgressBar(module.window, (module.window:GetWidth() - 4), 20)
		ProgressBar:SetMinMaxValues(0, TotalPageCount)
		ProgressBar:SetValue(0)
		ProgressBar:SetPoint('BOTTOM', module.window, 'BOTTOM', 0, 2)
		module.window.ProgressBar = ProgressBar

		--Position the Buttons
		module.window.Skip:SetPoint('BOTTOMLEFT', module.window.ProgressBar, 'TOPLEFT', 0, 2)
		module.window.Next:SetPoint('BOTTOMRIGHT', module.window.ProgressBar, 'TOPRIGHT', 0, 2)

		-- Adjust the content area to account for the new layout
		module.window.content = CreateFrame('Frame', 'SUI_Window_Content', module.window)
		module.window.content:SetPoint('TOP', module.window.Desc2, 'BOTTOM', 0, -2)
		module.window.content:SetPoint('BOTTOMLEFT', module.window.Skip, 'TOPLEFT', 0, 2)
		module.window.content:SetPoint('BOTTOMRIGHT', module.window.Next, 'TOPRIGHT', 0, 2)
	else
		--Position the Buttons
		module.window.Skip:SetPoint('BOTTOMLEFT', module.window, 'BOTTOMLEFT', 0, 2)
		module.window.Next:SetPoint('BOTTOMRIGHT', module.window, 'BOTTOMRIGHT', 0, 2)
	end

	local function LoadNextPage()
		--Hide anything attached to the Content frame
		for _, child in ipairs({module.window.content:GetChildren()}) do
			child:Hide()
		end

		-- If Reload is needed by the page flag it.
		if CurrentDisplay.RequireReload then
			ReloadNeeded = true
		end

		-- Show the next page
		module:FindNextPage()
	end

	module.window.Skip:SetScript(
		'OnClick',
		function(this)
			-- Perform the Page's Custom Skip action
			if CurrentDisplay.Skip then
				CurrentDisplay.Skip()
			end

			LoadNextPage()
		end
	)

	module.window.Next:SetScript(
		'OnClick',
		function(this)
			-- Perform the Page's Custom Next action
			if CurrentDisplay.Next then
				CurrentDisplay.Next()
			end

			LoadNextPage()
		end
	)

	module.window.Status = StdUi:Label(module.window, '', 9, nil, 60, 15)
	module.window.Status:SetPoint('TOPRIGHT', module.window, 'TOPRIGHT', -2, -2)

	-- Display first page
	module:FindNextPage()
	module.window.closeBtn:Hide()
	module.window:Show()
end

function module:OnInitialize()
	InitDone = true
	local Defaults = {
		FirstLaunch = true
	}
	if not SUI.DB.SetupWizard then
		SUI.DB.SetupWizard = Defaults
	else
		SUI.DB.SetupWizard = SUI:MergeData(SUI.DB.SetupWizard, Defaults, false)
	end
	module:WelcomePage()
	module:ProfileSetup()
	module:ModuleSelectionPage()
end

function module:OnEnable()
	-- If First launch, create a watcher frame that will trigger once everything is loaded in.
	if SUI.DB.SetupWizard.FirstLaunch or DisplayRequired then
		local LoadWatcher = CreateFrame('Frame')
		LoadWatcher:SetScript('OnEvent', LoadWatcherEvent)
		LoadWatcher:RegisterEvent('PLAYER_LOGIN')
		LoadWatcher:RegisterEvent('PLAYER_ENTERING_WORLD')
	end
end

function module:WelcomePage()
	local WelcomePage = {
		ID = 'WelcomePage',
		Name = 'Welcome',
		SubTitle = '',
		Desc1 = "Welcome to SpartanUI, This setup wizard help guide you through the inital setup of the UI and it's modules.",
		Desc2 = 'This setup wizard may be re-ran at any time via the SUI settings screen. You can access the SUI settings via the /sui chat command. For a full list of chat commands as well as common questions visit our wiki at http://wiki.spartanui.net',
		Display = function()
			local profiles = {}
			local currentProfile = SUI.SpartanUIDB:GetCurrentProfile()
			for _, v in pairs(SUI.SpartanUIDB:GetProfiles(tmpprofiles)) do
				if not (nocurrent and v == currentProfile) then
					profiles[#profiles + 1] = {text = v, value = v}
				end
			end

			local WelcomePage = CreateFrame('Frame', nil)
			WelcomePage:SetParent(module.window.content)
			WelcomePage:SetAllPoints(module.window.content)

			WelcomePage.Helm = StdUi:Texture(WelcomePage, 150, 150, 'Interface\\AddOns\\SpartanUI\\media\\Spartan-Helm')
			WelcomePage.Helm:SetPoint('CENTER', 0, 35)
			WelcomePage.Helm:SetAlpha(.6)

			if not select(4, GetAddOnInfo('Bartender4')) then
				module.window.BT4Warning =
					StdUi:Label(
					module.window,
					L['Bartender4 not detected! Please download and install Bartender4.'],
					25,
					nil,
					module.window:GetWidth(),
					40
				)
				module.window.BT4Warning:SetTextColor(1, .18, .18, 1)
				StdUi:GlueAbove(module.window.BT4Warning, module.window, 0, 20)
			end

			WelcomePage.ProfileCopyLabel =
				StdUi:Label(
				WelcomePage,
				L['If you would like to copy the configuration from another character you may do so below.']
			)

			WelcomePage.ProfileList = StdUi:Dropdown(WelcomePage, 200, 20, profiles)
			WelcomePage.CopyProfileButton = StdUi:Button(WelcomePage, 60, 20, 'COPY')
			WelcomePage.CopyProfileButton:SetScript(
				'OnClick',
				function(this)
					local ProfileSelection = module.window.content.WelcomePage.ProfileList:GetValue()
					if not ProfileSelection or ProfileSelection == '' then
						return
					end
					-- Copy profile
					SUI.SpartanUIDB:CopyProfile(ProfileSelection)
					-- Set the BT4 Profile
					Bartender4.db:SetProfile(SUI.SpartanUIDB.profile.SUIProper.Styles[SUI.SpartanUIDB.profile.Modules.Artwork.Style].BartenderProfile)
					-- Reload the UI
					ReloadUI()
				end
			)

			StdUi:GlueBottom(WelcomePage.ProfileCopyLabel, WelcomePage.Helm, 0, -35)
			StdUi:GlueBottom(WelcomePage.ProfileList, WelcomePage.ProfileCopyLabel, -31, -25)
			StdUi:GlueRight(WelcomePage.CopyProfileButton, WelcomePage.ProfileList, 2, 0)

			module.window.content.WelcomePage = WelcomePage
		end,
		Next = function()
			SUI.DB.SetupWizard.FirstLaunch = false
		end,
		RequireDisplay = SUI.DB.SetupWizard.FirstLaunch,
		Priority = true
	}
	module:AddPage(WelcomePage)
end

function module:ProfileSetup()
	--Hide Bartender4 Minimap icon.
	if Bartender4 then
		Bartender4.db.profile.minimapIcon.hide = true
		local LDBIcon = LibStub('LibDBIcon-1.0', true)
		LDBIcon['Hide'](LDBIcon, 'Bartender4')
	end
end

function module:ModuleSelectionPage()
	local ProfilePage = {
		ID = 'ModuleSelectionPage',
		Name = L['Enabled modules'],
		RequireReload = true,
		Priority = true,
		SubTitle = L['Enabled modules'],
		Desc1 = 'Below you can disable modules of SpartanUI',
		RequireDisplay = (not SUI.DB.SetupDone),
		Display = function()
			local window = SUI:GetModule('SetupWizard').window
			local SUI_Win = window.content
			local StdUi = window.StdUi

			--Container
			SUI_Win.ModSelection = CreateFrame('Frame', nil)
			SUI_Win.ModSelection:SetParent(SUI_Win)
			SUI_Win.ModSelection:SetAllPoints(SUI_Win)

			local itemsMatrix = {}

			-- List Components
			for name, submodule in SUI:IterateModules() do
				if (string.match(name, 'Component_')) then
					local RealName = string.sub(name, 11)
					if SUI.DB.EnabledComponents[RealName] == nil then
						SUI.DB.EnabledComponents[RealName] = true
					end

					local Displayname = string.sub(name, 11)
					if submodule.DisplayName then
						Displayname = submodule.DisplayName
					end
					local checkbox = StdUi:Checkbox(SUI_Win.ModSelection, Displayname, 120, 20)
					checkbox:HookScript(
						'OnClick',
						function()
							SUI.DB.EnabledComponents[RealName] = checkbox:GetValue()
						end
					)
					checkbox:SetChecked(SUI.DB.EnabledComponents[RealName])

					itemsMatrix[(#itemsMatrix + 1)] = checkbox
				end
			end

			local checkbox = StdUi:Checkbox(SUI_Win.ModSelection, L['Film Effects'], 120, 20)
			checkbox:HookScript(
				'OnClick',
				function()
					if checkbox:GetValue() then
						EnableAddOn('SpartanUI_FilmEffects')
					else
						DisableAddOn('SpartanUI_FilmEffects')
					end
				end
			)
			checkbox:SetChecked(select(4, GetAddOnInfo('SpartanUI_FilmEffects')))
			itemsMatrix[(#itemsMatrix + 1)] = checkbox

			checkbox = StdUi:Checkbox(SUI_Win.ModSelection, L['Spin cam'], 120, 20)
			checkbox:HookScript(
				'OnClick',
				function()
					if checkbox:GetValue() then
						EnableAddOn('SpartanUI_SpinCam')
					else
						DisableAddOn('SpartanUI_SpinCam')
					end
				end
			)
			checkbox:SetChecked(select(4, GetAddOnInfo('SpartanUI_SpinCam')))
			itemsMatrix[(#itemsMatrix + 1)] = checkbox

			StdUi:GlueTop(itemsMatrix[1], SUI_Win.ModSelection, -60, 0)

			local left, leftIndex = false, 1
			for i = 2, #itemsMatrix do
				if left then
					StdUi:GlueBelow(itemsMatrix[i], itemsMatrix[leftIndex], 0, -5)
					leftIndex = i
					left = false
				else
					StdUi:GlueRight(itemsMatrix[i], itemsMatrix[leftIndex], 5, 0)
					left = true
				end
			end
		end,
		Next = function()
			SUI.DB.SetupDone = true
		end,
		Skip = function()
			SUI.DB.SetupDone = true
		end
	}

	module:AddPage(ProfilePage)
end
