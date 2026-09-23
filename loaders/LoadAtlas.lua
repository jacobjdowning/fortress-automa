local xml2lua = require "libs.xml2lua"
local handler = require "libs.xmltree"

return function(atlasPath)
	atlasFile = io.open(atlasPath, "r")
	atlasString = atlasFile:read("*all")
	local parser = xml2lua.parser(handler)
	parser:parse(atlasString)
	local xoffset = 10 
	local yoffset = 10 

	-- Create Spritebatch
	local imageInfo = handler.root.TextureAtlas._attr
	local texturePath = atlasPath:sub(0, atlasPath:match'^.*()/') .. imageInfo.imagePath
	local texture = love.graphics.newImage(texturePath)
	local spriteBatch = love.graphics.newSpriteBatch(texture, 100, "dynamic")

	-- Create Quads
	local quads = {}
	local sprite
	-- This usually is done in the parser but I removed it because it was removing my names from the xml attributes
	handler.root.TextureAtlas.sprite.n = nil 
	for k,v in pairs(handler.root.TextureAtlas.SubTexture) do
		sprite = v._attr
		quads[sprite.name] = love.graphics.newQuad(sprite.x, sprite.y, sprite.width, sprite.height, imageInfo.width, imageInfo.height)
	end

	return spriteBatch, quads
end
