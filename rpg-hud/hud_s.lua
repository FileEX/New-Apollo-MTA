--[[
  @Developers: boszboszek(Patryk T.), Pevo(Przemysław B.), FileEX (Discord: FileEX#3656)
  @Contact: boszboszek - ptotczyk@gmail.com, Pevo - pb.pb@onet.pl, FileEX - fileex@int.pl
  @For: Apollo MTA
  @Resource: rpg-hud
  @File: hud_c.lua
  @File author: FileEX

  Zakaz używania/rozpowszechnania pliku bez zgody samych autorów(boszboszek, Pevo, FileEX).
  Złamanie owej licencji grozi konsekwencja prawną na mocy artykułu 278 Kodeksu karnego.
  Wszelkie prawa zastrzeżone.
]]--


addEvent('getUserAvatar', true); -- TODO create avatars from forum
addEventHandler('getUserAvatar',root,function()
	local av = 'avt.png';
	if not av then
		av = 'default.png';
	end

	triggerClientEvent(client, 'setUserAvatar', client, av);
end);

function toggleHud(player, toggle, default)
  if player and isElement(player) then
    if not toggle then
      default = (type(default) == "nil" and false or default);
    end

    triggerClientEvent(player, 'togglePlayerHud', player, toggle, default);
  end
end