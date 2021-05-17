local DuelBookEventFrame = CreateFrame("frame", "DuelBookEventFrame")
DuelBookEventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
DuelBookEventFrame:RegisterEvent("ADDON_LOADED")
DuelBookEventFrame:RegisterEvent("PLAYER_LOGOUT")
local currentPlayerName = UnitName("player")
if DuelBookDBPC == nil then 
	DuelBookDBPC = {}
end

--SLASH COMMANDS
-- 1. Pick DUELBOOK as the unique identifier.
-- 2. Pick /duelbook and  as slash commands 
-- 3. this will display the saved variable table data
SLASH_DUELBOOK1 = '/duelbook'; -- 3.
function SlashCmdList.DUELBOOK(msg, editbox) -- 4.

--get a list of keys (tkeys)in alphabetical order to use later
--local t = { [223]="asd", [23]="fgh", [543]="hjk", [7]="qwe" }
local tkeys = {}
-- populate the table that holds the keys
for k in pairs(DuelBookDBPC) do table.insert(tkeys, k) end
-- sort the keys
table.sort(tkeys)
-- use the keys to retrieve the values in the sorted order
--for _, k in ipairs(tkeys) do print(k, DuelBookDBPC[k][2]) end

local f = CreateFrame("Frame", "DuelBookFrame", UIParent)
f:SetSize(400, 400)
f:SetPoint("CENTER")
-- (2)
f:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
f:SetBackdropColor(0, 0, 0, .5)
f:SetBackdropBorderColor(0, 0, 0)
-- (3)
f:EnableMouse(true)
f:SetMovable(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:SetScript("OnHide", f.StopMovingOrSizing)
-- (4)
local close = CreateFrame("Button", "YourCloseButtonName", f, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", f, 30, 5)
close:SetScript("OnClick", function()
	f:Hide()
end)
-- (5)
local textHeader = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textHeader:SetPoint("TOP", 0, 20)
textHeader:SetText(currentPlayerName .. "'s Duel Book")
-- 6 output data
local textData = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textData:SetPoint("CENTER")

--container for all other columns to be scrolled
local fsc = CreateFrame("Frame", "fsc", f)
fsc:SetSize(400, 400)
fsc:SetPoint("Center")
fsc:Show()

--name title frame
local NAMEtitle = CreateFrame("Frame", "NAMEtitle", f)
NAMEtitle:SetSize(100, 350)
NAMEtitle:SetPoint("LEFT", 0, 20)

local textNAMEHeader = NAMEtitle:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textNAMEHeader:SetPoint("TOP")
textNAMEHeader:SetText("Name:")

--NAMES CONTAINER
local f2 = CreateFrame("Frame", "Names", fsc)
f2:SetSize(100, 350)
f2:SetPoint("LEFT")
f2:Show()

local textNameData = f2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textNameData:SetPoint("TOP", 0, 20)

local namesBuff = ""
--getting data in alphabetical order
local nameClassColorHolder = ""
for _, k in ipairs(tkeys) do 
	nameClassColorHolder = classChecker(k, 2)
	namesBuff = namesBuff .. nameClassColorHolder .. tostring(DuelBookDBPC[k][1]) .. "\n\n" end
--for k, v in pairs(DuelBookDBPC) do namesBuff = namesBuff .. tostring(v[1]) .. "\n\n" end
textNameData:SetText(namesBuff)
--print(namesBuff)

--class name title frame
local CLASStitle = CreateFrame("Frame", "CLASStitle", f)
CLASStitle:SetSize(100, 350)
CLASStitle:SetPoint("LEFT", 100, 20)

local textCLASSHeader = CLASStitle:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textCLASSHeader:SetPoint("TOP")
textCLASSHeader:SetText("Class:")

--CLASS CONTAINER
local f3 = CreateFrame("Frame", "Class", fsc)
f3:SetSize(100, 350)
f3:SetPoint("LEFT", 100, 0)
f3:Show()
local textClassData = f3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textClassData:SetPoint("TOP", 0, 20)

local classBuff = ""
--getting data in alphabetical order
local classColorHolder = ""
for _, k in ipairs(tkeys) do 
	classColorHolder = classChecker(k, 2)
	classBuff = classBuff .. classColorHolder .. tostring(DuelBookDBPC[k][2]) .. "\n\n" end
textClassData:SetText(classBuff)


--wins title frame
local WINStitle = CreateFrame("Frame", "WINStitle", f)
WINStitle:SetSize(100, 350)
WINStitle:SetPoint("LEFT", 200, 20)

local textWINSHeader = WINStitle:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textWINSHeader:SetPoint("TOP")
textWINSHeader:SetText("Wins:")

--WINS CONTAINER
local f4 = CreateFrame("Frame", "WINS", fsc)
f4:SetSize(100, 350)
f4:SetPoint("LEFT", 200, 0)

local textWinsData = f4:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textWinsData:SetPoint("TOP", 0, 20)

local winsBuff = ""
--getting data in alphabetical order
for _, k in ipairs(tkeys) do 
	if DuelBookDBPC[k][3] == 0 then winsBuff = winsBuff .. "\n\n" 
else
	winsBuff = winsBuff .. "|cFF00FF00" .. tostring(DuelBookDBPC[k][3]) .. "\n\n" 
end
end
textWinsData:SetText(winsBuff)

--make serparate frame for holding titles of columns
local LOSSEStitle = CreateFrame("Frame", "LOSSEStitle", f)
LOSSEStitle:SetSize(100, 350)
LOSSEStitle:SetPoint("LEFT", 300, 20)

local textLossesHeader = LOSSEStitle:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textLossesHeader:SetPoint("TOP")
textLossesHeader:SetText("Losses:")

--LOSS CONTAINER
local f5 = CreateFrame("Frame", "LOSSES", fsc)
f5:SetSize(100, 350)
f5:SetPoint("LEFT", 300, 0)


local textLossesData = f5:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
textLossesData:SetPoint("TOP", 0, 20)

local LossesBuff = ""
--getting data in alphabetical order
for _, k in ipairs(tkeys) do 
	if DuelBookDBPC[k][4] == 0 then LossesBuff = LossesBuff .. "\n\n"
else
	 LossesBuff = LossesBuff .. "|cFFFF0000" .. tostring(DuelBookDBPC[k][4]) .. "\n\n" 
end
end
textLossesData:SetText(LossesBuff)

f.SF = CreateFrame("ScrollFrame", "$parent_DF", f, "UIPanelScrollFrameTemplate")
f.SF:SetPoint("RIGHT", f,0,0)
f.SF:SetSize(400,350)
f.SF:SetScrollChild(fsc)
end

--beginning of tracking duels

DuelBookEventFrame:SetScript("OnEvent", function(self, event, ...)
	if DuelBookDBPC == nil then 
		DuelBookDBPC = {}
	end
	if(event == "CHAT_MSG_SYSTEM") then
		
		local duelTextOutcome = ...
		local stringDuel = "duel"

		--confirm word duel is in message, confirm fled is not in message, confirm playername is in the message(not another duel)
		-- finally call main call to do data stuff in duelDeducer
		if(msgTypeChecker(duelTextOutcome, stringDuel)) then
			if(msgFledChecker(duelTextOutcome) == nil) then
				if(msgPlayerNameChecker(duelTextOutcome) ~= nil) then
				duelDeducer(duelTextOutcome, currentPlayerName)
				end
			end
		end
	end
end)

--A few parses of the system message string to make sure this is a message worth looking at. No AFK messages etc messing with it. Make sure the player character was involved in the duel that created the system message etc

function msgTypeChecker(systemMessage, ending)

	return systemMessage:sub(-#ending) == ending
end

function msgFledChecker(systemMessage)

	local fledStartLoc, fledEndLoc = string.find(systemMessage, "fled")

	return fledStartLoc

end

function msgPlayerNameChecker(systemMessage)

	local playerNameStartLoc, playerNameEndLoc = string.find(systemMessage, currentPlayerName)

	return playerNameStartLoc

end

function has_key(table, key)
    return table[key]~=nil
end

function returnTable(table, key)
    return table[key]
end
	
--check class and return appropriate color
function classChecker(player, class)
	if DuelBookDBPC[player][class] == "Mage" then return  "|cFF40C7EB" 
	elseif DuelBookDBPC[player][class] == "Priest" then return  "|cFFFFFFFF" 
	elseif DuelBookDBPC[player][class] == "Warlock" then return  "|cFF8787ED" 
	elseif DuelBookDBPC[player][class] == "Rogue" then return  "|cFFFFF569"
	elseif DuelBookDBPC[player][class] == "Druid" then return  "|cFFFF7D0A" 
	elseif DuelBookDBPC[player][class] == "Shaman" then return  "|cFF0070DE" 
	elseif DuelBookDBPC[player][class] == "Hunter" then return  "|cFFA9D271" 
	elseif DuelBookDBPC[player][class] == "Paladin" then return  "|cFFF58CBA" 
	elseif DuelBookDBPC[player][class] == "Warrior" then return  "|cFFC79C6E" 
	else return "|cFFFFFFFF"  
	end
end

--figure out if player character won the duel or opponent. Push outcome into database

function duelDeducer(systemMessage, thePlayerName)

	s = systemMessage
	words = {}
	for w in s:gmatch("%S+") do table.insert(words, w) end	

	if(words[1]==thePlayerName) then
		opponentName = words[4]
		if has_key(DuelBookDBPC, opponentName) == false then 
			oppClassName, classFilename, classId = UnitClass("target")
			if classId == nil then oppClassName = nil end
			DuelBookDBPC[opponentName] = {opponentName, oppClassName, 1, 0}

		else if has_key(DuelBookDBPC, opponentName) == true then
			oppClassName, classFilename, classId = UnitClass("target")
			if classId == nil then oppClassName = nil end
			print(has_key(DuelBookDBPC, opponentName))

			opponenetTableRef = returnTable(DuelBookDBPC, opponentName)
			opponenetTableRef[3] = opponenetTableRef[3] + 1

			DuelBookDBPC[opponentName] = opponenetTableRef

			updatedOpTableRef = returnTable(DuelBookDBPC, opponentName)
		end
	end


	else if(words[4]==thePlayerName) then
		opponentName = words[1]
		if has_key(DuelBookDBPC, opponentName) == false then 
			
			oppClassName, classFilename, classId = UnitClass("target")
			if classId == nil then oppClassName = nil end
			DuelBookDBPC[opponentName] = {opponentName, oppClassName, 0, 1}

		else if has_key(DuelBookDBPC, opponentName) == true then

			oppClassName, classFilename, classId = UnitClass("target")
			if classId == nil then oppClassName = nil end
			print(has_key(DuelBookDBPC, opponentName))

			opponenetTableRef = returnTable(DuelBookDBPC, opponentName)
			opponenetTableRef[4] = opponenetTableRef[4] + 1

			DuelBookDBPC[opponentName] = opponenetTableRef

			updatedOpTableRef = returnTable(DuelBookDBPC, opponentName)
		end
		end
	end
end
end