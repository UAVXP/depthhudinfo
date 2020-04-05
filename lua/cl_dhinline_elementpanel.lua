////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu                                       //
////////////////////////////////////////////////

include( 'CtrlColor.lua' )
include( 'DhCheckPos.lua' )
include( 'control_presets.lua' )

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// DERMA PANEL .

function dhinline.Util_FrameGetExpandTable( myPanel )
	local expandTable = {}
	
	for k,subtable in pairs( myPanel.Categories ) do
		table.insert(expandTable, subtable[1]:GetExpanded())
		
	end
	
	return expandTable
end

function dhinline.Util_AppendPanel( myPanel, thisPanel )
	local toAppendIn = myPanel.Categories[#myPanel.Categories][1].List
	
	thisPanel:SetParent( toAppendIn )
	toAppendIn:AddItem( thisPanel )
	
end

function dhinline.Util_AppendCheckBox( myPanel, title, cvar )

	local checkbox = vgui.Create( "DCheckBoxLabel" )
	checkbox:SetText( title )
	checkbox:SetConVar( cvar )
	
	dhinline.Util_AppendPanel( myPanel, checkbox )
	
end

function dhinline.Util_AppendLabel( myPanel, sText, optiSize, optbWrap )

	local label = vgui.Create( "DLabel" )
	label:SetText( sText )
	
	if optiSize then
		label:SetWrap( true )
		label:SetContentAlignment( 2 )
		label:SetSize( myPanel.W_WIDTH, optiSize )
		
	end
	
	if optbWrap then
		label:SetWrap( true )
		
	end
	
	dhinline.Util_AppendPanel( myPanel, label )
	
end

function dhinline.Util_AppendSlider( myPanel, sText, sCvar, fMin, fMax, iDecimals)
	local slider = vgui.Create("DNumSlider")
	slider:SetText( sText )
	slider:SetMin( fMin )
	slider:SetMax( fMax )
	slider:SetDecimals( iDecimals )
	slider:SetConVar( sCvar )
	
	dhinline.Util_AppendPanel( myPanel, slider )
end

function dhinline.Util_MakeFrame( width, height )
	local myPanel = vgui.Create( "DFrame" )
	local border = 4
	
	myPanel.W_HEIGHT = height - 20
	myPanel.W_WIDTH = width - 2 * border
	
	myPanel:SetPos( ScrW() * 0.5 - width * 0.5 , ScrH() * 0.5 - height * 0.5 )
	myPanel:SetSize( width, height )
	myPanel:SetTitle( DHINLINE_NAME )
	myPanel:SetVisible( false )
	myPanel:SetDraggable( true )
	myPanel:ShowCloseButton( true )
	myPanel:SetDeleteOnClose( false )
	
	myPanel.Contents = vgui.Create( "DPanelList", myPanel )
	myPanel.Contents:SetPos( border , 22 + border )
	myPanel.Contents:SetSize( myPanel.W_WIDTH, height - 2 * border - 22 )
	myPanel.Contents:SetSpacing( 5 )
	myPanel.Contents:EnableHorizontal( false )
	myPanel.Contents:EnableVerticalScrollbar( false )
	
	myPanel.Categories = {}
	
	return myPanel
end

function dhinline.Util_MakeCategory( myPanel, sTitle, bExpandDefault )
	local category = vgui.Create("DCollapsibleCategory", myPanel.Contents)
	category.List  = vgui.Create("DPanelList", category )
	table.insert( myPanel.Categories, {category, bExpandDefault} )
	category:SetSize( myPanel.W_WIDTH, 50 )
	category:SetLabel( sTitle )
	
	category.List:EnableHorizontal( false )
	category.List:EnableVerticalScrollbar( false )
	
	return category
end

function dhinline.Util_ApplyCategories( myPanel )
	for k,subtable in pairs( myPanel.Categories ) do
		subtable[1]:SetExpanded( opt_tExpand and (opt_tExpand[k] and 1 or 0) or subtable[2] )
		subtable[1].List:SetSize( myPanel.W_WIDTH, myPanel.W_HEIGHT - #myPanel.Categories * 10 - 10 )
		subtable[1]:SetSize( myPanel.W_WIDTH, myPanel.W_HEIGHT - #myPanel.Categories * 10 )
		
		subtable[1].List:PerformLayout()
		subtable[1].List:SizeToContents()
		
		subtable[1]:SetContents( subtable[1].List )
		
		myPanel.Contents:AddItem( subtable[1] )
	end
	
end

function dhinline.Util_AppendPresetPanel( myPanel, data )
	local ctrl = vgui.Create( "ControlPresets", self )
	
	ctrl:SetPreset( data.folder )
	
	if ( data.options ) then
		for k, v in pairs( data.options ) do
			if ( k ~= "id" ) then
				ctrl:AddOption( k, v )
			end
		end
	end
	
	if ( data.cvars ) then
		for k, v in pairs( data.cvars ) do
			ctrl:AddConVar( v )
		end
	end
	
	dhinline.Util_AppendPanel( myPanel, ctrl)
end

function dhinline.BuildMenu( opt_tExpand )
	if dhinline.DermaPanel then dhinline.DermaPanel:Remove() end
	
	local MY_VERSION, SVN_VERSION, DOWNLOAD_LINK = dhinline.GetVersionData()
	
	dhinline.DermaPanel = dhinline.Util_MakeFrame( 300, ScrH() * 0.8 )
	local refPanel = dhinline.DermaPanel
	
	local theme = dhinline_theme.GetCurrentThemeObject()
	
	dhinline.Util_MakeCategory( refPanel, "General [Theme : "..theme:GetDisplayName().."]", 1 )
	dhinline.Util_AppendCheckBox( refPanel, "Enable" , "dhinline_core_enable" )
	dhinline.Util_AppendCheckBox( refPanel, "Disable Base HUD" , "dhinline_core_disabledefault" )
	
	dhinline.Util_AppendLabel( refPanel, "Theme selection :" )
	-- Theme Multichoice
	do
		local ThemeMultiChoice = vgui.Create( "DMultiChoice" )
		
		ThemeMultiChoice.ConversionTable = {}
		ThemeMultiChoice.Current = dhinline_theme.GetCurrentTheme()
		ThemeMultiChoice.Preselect = 1
		
		for k,sThemeName in pairs(dhinline_theme.GetNamesTable()) do
			ThemeMultiChoice:AddChoice( dhinline_theme.GetThemeObject( sThemeName ):GetDisplayName() )
			table.insert( ThemeMultiChoice.ConversionTable , sThemeName )
			
			if sThemeName == ThemeMultiChoice.Current then 
				ThemeMultiChoice.Preselect = #ThemeMultiChoice.ConversionTable
			end
		end
		
		ThemeMultiChoice.OnSelect = function(index,value,data)
			local selection = ThemeMultiChoice.ConversionTable[value]
			if selection ~= ThemeMultiChoice.Current then
				local myExpand = dhinline.Util_FrameGetExpandTable( refPanel )
				dhinline.SetTheme( selection )
				dhinline.BuildMenu( myExpand )
				dhinline.ShowMenu()
			end
		end
		
		ThemeMultiChoice:ChooseOptionID(ThemeMultiChoice.Preselect)
	
		ThemeMultiChoice:PerformLayout()
		ThemeMultiChoice:SizeToContents()
		
		dhinline.Util_AppendPanel( refPanel, ThemeMultiChoice )
	end
	
	
	dhinline.Util_AppendLabel( refPanel, "Elements presets for "..theme:GetDisplayName().." :" )
	dhinline.Util_AppendPresetPanel( refPanel,
	{
		options = { ["default"] = theme:GetElementsDefaultsTable() },
		cvars = theme:GetElementsConvarTable(),
		folder = "dhinline_elements_"..theme:GetRawName()
	} )
	
	
	dhinline.Util_AppendLabel( refPanel, "Theme presets for "..theme:GetDisplayName().." :" )
	dhinline.Util_AppendPresetPanel( refPanel,
	{
		options = { ["default"] = theme:GetThemeDefaultsTable() },
		cvars = theme:GetThemeConvarTable(),
		folder = "dhinline_themes_"..theme:GetRawName()
	} )
	
	dhinline.Util_AppendLabel( refPanel, "" )
	-- Reload Button
	do
		local ThemeListReloadButton = vgui.Create("DButton")
		ThemeListReloadButton:SetText( "Reload Themes" )
		ThemeListReloadButton.DoClick = function()
			local myExpand = dhinline.Util_FrameGetExpandTable( refPanel )
			dhinline.LoadAllThemes()
			dhinline.BuildMenu( myExpand )
			dhinline.ShowMenu()
		end
		dhinline.Util_AppendPanel( refPanel, ThemeListReloadButton )
	end
	
	
	--Helper label
	do
		local GeneralTextLabelMessage = "The command \"dhinline_menu\" calls this menu.\n"
		if not (MY_VERSION and SVN_VERSION and (MY_VERSION < SVN_VERSION)) then
			GeneralTextLabelMessage = GeneralTextLabelMessage .. "Example : To assign " .. DHINLINE_NAME .. " menu to F7, type in the console :"
			
		else
			GeneralTextLabelMessage = GeneralTextLabelMessage .. "Your version is "..MY_VERSION.." and the updated one is "..SVN_VERSION.." ! You should update !"
			
		end
		dhinline.Util_AppendLabel( refPanel, GeneralTextLabelMessage, 50, true )
		
	end
	--Helper multiline
	do
		local GeneralCommandLabel = vgui.Create("DTextEntry")
		local hasUpdate = (MY_VERSION and SVN_VERSION and (MY_VERSION < SVN_VERSION) and DOWNLOAD_LINK)
		
		if not hasUpdate then
			GeneralCommandLabel:SetText( "bind \"F7\" \"dhinline_menu\"" )
			
		else
			GeneralCommandLabel:SetText( DOWNLOAD_LINK )
			
		end
		GeneralCommandLabel:SetEditable( false )
		if hasUpdate then
			GeneralCommandLabel:SetMultiline( true )
			GeneralCommandLabel:SetSize( refPanel.W_WIDTH, 60 )
		end

		dhinline.Util_AppendPanel( refPanel, GeneralCommandLabel )
		
	end
		
	
	
	dhinline.Util_MakeCategory( refPanel, "Elements", 0 )
	dhinline.Util_AppendPresetPanel( refPanel,
	{
		options = { ["default"] = theme:GetElementsDefaultsTable() },
		cvars = theme:GetElementsConvarTable(),
		folder = "dhinline_elements_"..theme:GetRawName()
	} )
	
	do
		local ElementsList = vgui.Create( "DPanelList" )
		ElementsList:SetSize( refPanel.W_WIDTH, refPanel.W_HEIGHT * 0.6 )
		ElementsList:SetSpacing( 5 )
		ElementsList:EnableHorizontal( false )
		ElementsList:EnableVerticalScrollbar( true )
		local names = theme:GetElementsNames()
		for k,name in pairs(names) do
			local myElement = theme:GetElement( name )
			
			local sFullConvarName = "dhinline_element_".. theme:GetRawName() .."_".. myElement:GetRawName()
			
			local ListCheck = vgui.Create( "DhCheckPos" )
			ListCheck:SetText( myElement:GetDisplayName() )
			ListCheck:SetConVar( sFullConvarName )
			ListCheck:SetConVarX( sFullConvarName .. "_x" )
			ListCheck:SetConVarY( sFullConvarName .. "_y" )
			ListCheck:SetMinMax( 0 , dhinline.GetGridDivideMax() )

			ListCheck.button.DoClick = function()
				dhinline.SetVar( sFullConvarName .. "_x", myElement.DefaultGridPosX )
				dhinline.SetVar( sFullConvarName .. "_y", myElement.DefaultGridPosY )
			end
			ElementsList:AddItem( ListCheck ) -- Add the item above
		end
		
		dhinline.Util_AppendPanel( refPanel, ElementsList )
	end
	
	-- Reload Button
	do
		local ElementReloadButton = vgui.Create("DButton")
		ElementReloadButton:SetText( "Reload Theme Elements" )
		ElementReloadButton.DoClick = function()
			local myExpand = dhinline.Util_FrameGetExpandTable( refPanel )
			dhinline.LoadCurrentTheme()
			dhinline.SetTheme( selection )
			dhinline.BuildMenu( myExpand )
			dhinline.ShowMenu()
		end
		
		dhinline.Util_AppendPanel( refPanel, ElementReloadButton )
		
	end
	
	
	dhinline.Util_MakeCategory( refPanel, "UI Design", 0 )
	-- Revert Button
	do
		local UIStyleRevertButton = vgui.Create("DButton")
		UIStyleRevertButton:SetText( "Revert Theme back to Defaults" )
		UIStyleRevertButton.DoClick = function()
			dhinline.RevertTheme()
		end
		
		dhinline.Util_AppendPanel( refPanel, UIStyleRevertButton )
		
	end
	
	dhinline.Util_AppendPresetPanel( refPanel,
	{
		options = { ["default"] = theme:GetThemeDefaultsTable() },
		cvars = theme:GetThemeConvarTable(),
		folder = "dhinline_themes_"..theme:GetRawName()
	} )
	dhinline.Util_AppendSlider( refPanel, "Spacing",  "dhinline_core_ui_spacing", 0, 2, 1 )
	
	local themeParamsNames = theme:GetParametersNames()
	for k,sName in pairs(themeParamsNames) do
		local myPanel = theme:BuildParameterPanel( sName )
		dhinline.Util_AppendPanel( refPanel, myPanel )
	end
	
	dhinline.Util_ApplyCategories( refPanel )
end

function dhinline.ShowMenu()
	if not dhinline.DermaPanel then
		dhinline.BuildMenu()
	end
	//dhinline.DermaPanel:Center()
	dhinline.DermaPanel:MakePopup()
	dhinline.DermaPanel:SetVisible( true )
end

function dhinline.DestroyMenu()
	if dhinline.DermaPanel then
		dhinline.DermaPanel:Remove()
		dhinline.DermaPanel = nil
	end
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// SANDBOX PANEL .

function dhinline.Panel(Panel)	
	Panel:AddControl("Checkbox", {
			Label = "Enable", 
			Description = "Enable", 
			Command = "dhinline_core_enable" 
		}
	)
	Panel:AddControl("Checkbox", {
			Label = "Disable Base HUD",
			Description = "Disable Base HUD",
			Command = "dhinline_core_disabledefault" 
		}
	)
	Panel:AddControl("Button", {
			Label = "Open Menu (dhinline_menu)", 
			Description = "Open Menu (dhinline_menu)", 
			Command = "dhinline_menu"
		}
	)
	
	Panel:Help("To trigger the menu in any gamemode, type dhinline_menu in the console, or bind this command to any key.")
end

function dhinline.AddPanel()
	spawnmenu.AddToolMenuOption("Options","Player",DHINLINE_NAME,DHINLINE_NAME,"","",dhinline.Panel,{SwitchConVar = 'dhinline_core_enable'})
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// MOUNT FCTS.

function dhinline.MountMenu()
	concommand.Add( "dhinline_menu", dhinline.ShowMenu )
	concommand.Add( "dhinline_call_menu", dhinline.ShowMenu )
	hook.Add( "PopulateToolMenu", "AddDepthHUDInlinePanel", dhinline.AddPanel )
end

function dhinline.UnmountMenu()
	dhinline.DestroyMenu()

	concommand.Remove( "dhinline_call_menu" )
	concommand.Remove( "dhinline_menu" )
	hook.Remove( "PopulateToolMenu", "AddDepthHUDInlinePanel" )
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////