--[[
  @Developers: boszboszek(Patryk T.), Pevo(Przemysław B.), FileEX (Discord: FileEX#3656)
  @Contact: boszboszek - ptotczyk@gmail.com, Pevo - pb.pb@onet.pl, FileEX - fileex@int.pl
  @For: Apollo MTA
  @Resource: rpg-notif
  @File: notif_class.lua
  @File author: FileEX

  Zakaz używania/rozpowszechnania pliku bez zgody samych autorów(boszboszek, Pevo, FileEX).
  Złamanie owej licencji grozi konsekwencja prawną na mocy artykułu 278 Kodeksu karnego.
  Wszelkie prawa zastrzeżone.
]]--


notif = {};
setmetatable(notif, {__call = function(o, ...) return o:constructor(...) end, __index = notif});

local screenX, screenY = guiGetScreenSize();
local zoom = (1280 / screenX);

local notifTex = DxTexture(':rpg-files/images/notifications/bg.png','argb',false,'clamp');
local notifFont = exports['rpg-files']:getFont('Krub-Light', 12);

local notifsnd;

function notif:constructor()
	self.__init = function()
		self.notifs = {};
	end

	self.render = function() self:draw(self); end;

	self.remove = function(o, i) if self.notifs[i] then self.notifs[i].tick = getTickCount(); self.notifs[i].state = 'hide'; end; end;

	self.new = function(o, title, text, showTime)
		if #self.notifs + 1 == 1 then
			addEventHandler('onClientRender',root,self.render);
		end

		if #self.notifs + 1 > 5 then
			self:remove(5);
			Timer(function()
				table.insert(self.notifs, 1, {title = title, text=text, showTime=showTime, tick=getTickCount(),state='show',x=0});
			end,1400,1)
		end

		if #self.notifs + 1 <= 5 then
			table.insert(self.notifs, 1, {title = title, text=text, showTime=showTime, tick=getTickCount(),state='show',x=0});
		end

		if notifsnd and isElement(notifsnd) then
			notifsnd:destroy();
		end
			-- notifsnd = Sound(':rpg-files/sounds/notif.mp3', false,false);
	end

	self.__init();

	return self;
end

function notif:draw()
	for k,v in ipairs(self.notifs) do
		if v.state == 'show' then
			v.x = interpolateBetween(screenX + 50 / zoom, 0, 0, screenX - 230 / zoom, 0,0, (getTickCount() - v.tick) / 1400, 'InQuad');
			dxDrawImage(v.x, -12 + (k * 120) / zoom, 210 / zoom, 100 / zoom, notifTex, 0,0,0, 0xFFFFFFFF,false);
			dxDrawText(v.title, v.x + (80 / zoom), -10 + (k * 120) / zoom, 150 / zoom, 150 / zoom, 0xFFFFFFFF, 1.0 / zoom, 0.9 / zoom, notifFont,'left', 'top');
			dxDrawText(v.text, v.x + (10 / zoom), 7 + (k * 120) / zoom, 150 / zoom, 150 / zoom, 0xFFFFFFFF, 0.9 / zoom, notifFont, 'left', 'top');
			if (getTickCount() - v.tick) / 1400 > 1 then
				v.tick = getTickCount();
				v.state = 'const';
			end
		elseif v.state == 'const' then
			dxDrawImage(v.x, -12 + (k * 120) / zoom, 210 / zoom, 100 / zoom, notifTex, 0,0,0, 0xFFFFFFFF,false);
			dxDrawText(v.title, v.x + (80 / zoom), -10 + (k * 120) / zoom, 150 / zoom, 150 / zoom, 0xFFFFFFFF, 1.0 / zoom, 0.9 / zoom, notifFont,'left', 'top');
			dxDrawText(v.text, v.x + (10 / zoom), 7 + (k * 120) / zoom, 150 / zoom, 150 / zoom, 0xFFFFFFFF, 0.9 / zoom, notifFont, 'left', 'top');
			if (getTickCount() - v.tick) / v.showTime > 1 then
				v.tick = getTickCount();
				v.state = 'hide';
			end
		elseif v.state == 'hide' then
			v.x = interpolateBetween(screenX - 230 / zoom, 0,0, screenX + 50 / zoom, 0,0, (getTickCount() - v.tick) / 1400, 'OutQuad');
			dxDrawImage(v.x, -12 + (k * 120) / zoom, 210 / zoom, 100 / zoom, notifTex, 0,0,0, 0xFFFFFFFF,false);
			dxDrawText(v.title, v.x + (80 / zoom), -10 + (k * 120) / zoom, 150 / zoom, 150 / zoom, 0xFFFFFFFF, 1.0 / zoom, 0.9 / zoom, notifFont,'left', 'top');
			dxDrawText(v.text, v.x + (10 / zoom), 7 + (k * 120) / zoom, 150 / zoom, 150 / zoom, 0xFFFFFFFF, 0.9 / zoom, notifFont, 'left', 'top');
			if (getTickCount() - v.tick) / 1400 > 1 then
				table.remove(self.notifs, k);
				if #self.notifs <= 0 then
					removeEventHandler('onClientRender',root,self.render);
				end
			end
		end
	end
end