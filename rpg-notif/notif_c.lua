--[[
  @Developers: boszboszek(Patryk T.), Pevo(Przemysław B.), FileEX (Discord: FileEX#3656)
  @Contact: boszboszek - ptotczyk@gmail.com, Pevo - pb.pb@onet.pl, FileEX - fileex@int.pl
  @For: Apollo MTA
  @Resource: rpg-notif
  @File: notif_c.lua
  @File author: FileEX

  Zakaz używania/rozpowszechnania pliku bez zgody samych autorów(boszboszek, Pevo, FileEX).
  Złamanie owej licencji grozi konsekwencja prawną na mocy artykułu 278 Kodeksu karnego.
  Wszelkie prawa zastrzeżone.
]]--


local notifClass = notif();
local defaultShowTime = 5000;

function createNotif(title,text,showTime)
	local showTime = showTime;
	if not showTime then
		showTime = defaultShowTime;
	end
	notifClass:new(title,text,showTime);
  return true;
end

addEvent('createNotification', true)
addEventHandler('createNotification',localPlayer,function(t,tt,sh)
	createNotif(t,tt,sh);
end);