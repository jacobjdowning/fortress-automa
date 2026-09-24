local UI_Renderer = {}

UI_Renderer.batch, UI_Renderer.quads = require("loaders/LoadAtlas")("asset/ui_atlas.xml")
UI_Renderer.stack = {}

function UI_Renderer:pushWidget(widget)
	table.insert(self.stack, widget)
end

function UI_Renderer:popWidget()
	return table.remove(self.stack)
end

function UI_Renderer:removeWidget(widget)
	for k, v in pairs(self.stack) do
		if v == widget then
			table.remove(self.stack, k)
			return
		end
	end
end

function UI_Renderer:update()
	self.batch:clear()
	for i = #self.stack, 1, -1 do
		self.stack[i]:batch(self.batch)
	end
	self.batch:flush()
end

function UI_Renderer:render()
	love.graphics.draw(self.batch)
end

local Widget = {
	clickable = false
}

function Widget:new(obj)
	obj = obj or {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Widget:batch(batch)
	batch:add(
		UI_Renderer.quads["banner_classic_curtainimg.png"],
		70,
		70
	)
end

return {
	UI_Renderer = UI_Renderer,
	Widget = Widget,
}
