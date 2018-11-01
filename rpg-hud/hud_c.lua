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

local newHud;

newHud = hud();
-- TODO check hud state from user settings
newHud:toggleHud(true);

addEvent('armorChanged',false);
addEventHandler('armorChanged', localPlayer, function(armor)
    if armor > 0 and not uCheck.valid then
        newHud:animateHud('left');
        uCheck = Timer(function()
            if localPlayer.armor <= 0 then
                newHud:animateHud('right');
                uCheck:destroy();
                uCheck = nil;
            end
        end, 2000, 1);
    end
end, false, 'low');

function toggleHud(toggle, default)
    if not toggle then
      default = (type(default) == "nil" and false or default);
    end

    if not newHud then
        newHud = hud();
    end
    newHud:toggleHud(b,d);
end

addEvent('togglePlayerHud',true);
addEventHandler('togglePlayerHud',localPlayer,function(b,d)
    if not newHud then
        newHud = hud();
    end

    newHud:toggleHud(b,d);
end);

addEventHandler("onClientPlayerQuit",root,function()
    if newHud then
        newHud:destructor();
    end
end);