
--[[ Create the main frame ]]--
local main_frame = CreateFrame("Frame", nil, UIParent)
main_frame:SetScript("OnLoad", InitializeMainFrame)
main_frame:SetScript("OnEvent", MainFrameEventHandler)

local function InitializeMainFrame()
    print("Howdy")
    main_frame:RegisterEvent("ADDON_LOADED")
    main_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    main_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    main_frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
    main_frame:SetWidth(100)
    main_frame:SetHeight(100)
    main_frame:SetPoint("CENTER", 0, 0)
    main_frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    main_frame:SetBackdropColor(0,0,0,1)
    main_frame.text = main_frame:CreateFontString(nil, "ARTWORK")
    main_frame.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
    main_frame.text:SetText("Howdy!")
    main_frame.text:SetPoint("TOPLEFT",10,-10)
    main_frame:Show()
end

local function MainFrameEventHandler(event, ...)
    print(event)
end

