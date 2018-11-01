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

hud = {};
setmetatable(hud, {__call = function(o, ...) return o:constructor(...) end, __index = hud});

local screenX, screenY = guiGetScreenSize();
local zoom = (1280 / screenX);
local textures = {'armor_bar','armor_icon','bar_border','circle','desire_bar','desire_icon','health_icon','hunger_bar','hunger_icon','money_icon'};
local tex = {};

local tick, newHp, uCheck;

for k,v in pairs(textures) do
    tex[k] = DxTexture(':rpg-files/images/hud/'..v..'.png','argb',false,'clamp');
end

local mask = DxTexture('circleMask.png');
local sh = DxShader('av.fx');

sh:setValue('circleMask', mask);

function hud:constructor()
    self.__init = function()
        self.simulationHud = false;
        self.tick = false;
        self.anim = false;
        self.dir = '';
        self.offsetX = 0;
        self.offset = 30;
        self.animateHp = false;
    end

    self.renderHud = function() self:draw(self); end;
    self.toggleHud = function(_,b,d) _G[b and 'addEventHandler' or 'removeEventHandler']('onClientRender', root, self.renderHud); if b then triggerServerEvent('getUserAvatar', localPlayer); for _,v in ipairs({'money','health','weapon','clock','armour'}) do setPlayerHudComponentVisible(v,false); end else if d then for _,v in ipairs({'money','health','weapon','clock','armour'}) do setPlayerHudComponentVisible(v,true); end end end; end;

    self.toggleSimulationHud = function(_,b) self.simulationHud = not self.simulationHud; _G[b and 'addEventHandler' or 'removeEventHandler']('onClientRender', root, self.renderHud); end;

    self.animateHud = function(_, dir) self.dir = dir; self.tick = getTickCount(); self.anim = true; end;

    self.__init();

    return self;
end

function hud:destructor()
    _G['self'] = nil;
    if uCheck.valid then
        uCheck:destroy();
    end
    mask:destroy();
    sh:destroy();
    for k,v in ipairs(tex) do
        v:destroy();
    end
    tex = nil;
    tick,newHp,uCheck = nil,nil,nil;
    collectgarbage('collect');
end

function hud:draw()
    if self.anim then
        self.offsetX = interpolateBetween(self.dir == 'left' and 0 or (self.dir == 'right') and self.offset, 0,0, self.dir == 'left' and self.offset or (self.dir == 'right') and 0, 0, 0, (getTickCount() - self.tick) / 1200, 'Linear');
        if (getTickCount() - self.tick) / 1200 > 1 then
            self.anim = false;
            self.tick = false;
        end
    end

    if self.animateHp then
        localPlayer.health = interpolateBetween(localPlayer.health, 0,0, newHp, 0,0, (getTickCount() - tick) / 1300, 'Linear');
        if (getTickCount() - tick) / 1300 > 1 then
            self.animateHp = false;
            tick = nil;
            newHp = nil;
        end
    end

    dxDrawImage(screenX - 30 - self.offsetX / zoom, 30 / zoom, 20 / zoom, 80 / zoom,tex[3], 0,0,0, 0xFFFFFFFF,false);
    dxDrawImageSection(screenX - 30 - self.offsetX / zoom, 109 / zoom, 20 / zoom, (-81 / zoom) * (50 / 100), 0,0, 30, (50 / 100) * 85,tex[8]);
    dxDrawImage(screenX - 30 - self.offsetX / zoom, 5 / zoom, 20 / zoom, 20 / zoom, tex[9], 0,0,0, 0xFFFFFFFF,false);

    dxDrawImage(screenX - 60 - self.offsetX / zoom, 30 / zoom, 20 / zoom, 80 / zoom, tex[3], 0,0,0, 0xFFFFFFFF,false);
    dxDrawImageSection(screenX - 60 - self.offsetX / zoom, 109 / zoom, 20 / zoom, (-81 / zoom) * (70 / 100), 0,0, 30, (70 / 100) * 85, tex[5]);
    dxDrawImage(screenX - 60 - self.offsetX / zoom, 5 / zoom, 20 / zoom, 20 / zoom, tex[6], 0,0,0, 0xFFFFFFFF,false);
    
    if localPlayer.armor > 0 then
        dxDrawImage(screenX - 30 / zoom, 30 / zoom, 20 / zoom, 80 / zoom, tex[3], 0,0,0, 0xFFFFFFFF,false);
        dxDrawImageSection(screenX - 30 / zoom, 109 / zoom, 20 / zoom, (-81 / zoom) * (localPlayer.armor / 100), 0,0, 30, (localPlayer.armor / 100) * 85, tex[1]);
        dxDrawImage(screenX - 30 / zoom, 5 / zoom, 20 / zoom, 20 / zoom, tex[2], 0,0,0, 0xFFFFFFFF,false);
    end

    dxDrawImage(screenX - 120 - self.offsetX / zoom, 5 / zoom, 50 / zoom, 50 / zoom, tex[4], 0,0,0, 0xFFFFFFFF,false);
    dxDrawImage(screenX - 120 - self.offsetX / zoom, 5 / zoom, 50 / zoom, 50 / zoom, sh, 0,0,0, 0xFFFFFFFF,false);

    dxDrawImageSection(screenX - 105 - self.offsetX / zoom, 60 / zoom, (30 / zoom) * ((localPlayer.health >= 66.7 and localPlayer.health - 66.7 or 0) / 33.3), 30 / zoom, 0, 0, ((localPlayer.health - 1.4 >= 66.7 and localPlayer.health - 66.7 or 0) / 33.3) * 43, 34,tex[7]);
    dxDrawImageSection(screenX - 140 - self.offsetX / zoom, 60 / zoom, (30 / zoom) * ((localPlayer.health <= 66.7 and (localPlayer.health >= 33.3 and localPlayer.health - 33.3 or 0) or 66.7) / 66.7), 30 / zoom, 0, 0, ((localPlayer.health <= 66.7 and (localPlayer.health >= 33.3 and localPlayer.health - 33.3 or 0) or 66.7) / 66.7) * 43, 34,tex[7]);
    dxDrawImageSection(screenX - 175 - self.offsetX / zoom, 60 / zoom, (30 / zoom) * ((localPlayer.health <= 33.3 and (localPlayer.health > 0 and localPlayer.health or 0) or 33.3) / 33.3), 30 / zoom, 0, 0, ((localPlayer.health <= 33.3 and (localPlayer.health > 0 and localPlayer.health or 0) or 33.3) / 33.3) * 43, 34,tex[7]);

    dxDrawImage(screenX - 210 - self.offsetX / zoom, 20 / zoom, 20 / zoom, 20 / zoom, tex[10], 0,0,0, 0xFFFFFFFF,false);
    dxDrawText(string.format("%08.f",localPlayer:getMoney()), screenX - 185 - self.offsetX / zoom, 20 / zoom, 150 / zoom, 150 / zoom, tocolor(212,145,0,255), 1.1 / zoom, 'default-bold');
end

addEventHandler("onClientPlayerDamage",root,function(_,_,_,l)
    if source == localPlayer then
        tick = getTickCount();
        newHp = source.health - l;
        newHud.animateHp = true;
        cancelEvent();
    end
end);

addEvent('setUserAvatar',true);
addEventHandler('setUserAvatar',localPlayer,function(av)
    local avt = DxTexture(av);
    if avt then
        sh:setValue('picture', avt);
    end
end);