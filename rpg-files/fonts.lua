--[[
  @Developers: boszboszek(Patryk T.), Pevo(Przemysław B.), FileEX (Discord: FileEX#3656)
  @Contact: boszboszek - ptotczyk@gmail.com, Pevo - pb.pb@onet.pl, FileEX - fileex@int.pl
  @For: Apollo MTA
  @Resource: rpg-files
  @File: fonts.lua
  @File author: FileEX

  Zakaz używania/rozpowszechnania pliku bez zgody samych autorów(boszboszek, Pevo, FileEX).
  Złamanie owej licencji grozi konsekwencja prawną na mocy artykułu 278 Kodeksu karnego.
  Wszelkie prawa zastrzeżone.
]]--

local fonts = {};

function getFont(font,size)
    if fonts[font] and fonts[font][size] then
        return fonts[font][size].element;
    else
        fonts[font] = {
            [size] = {
                element = DxFont('fonts/'..font..'.ttf',size),
            },
        };
        return fonts[font][size].element;
    end
end
