local dump = require("utils").dump

--- UI_Renderer
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


--Widget
local Widget = {
	clickable = false,
	x = 0,
	y = 0,
}

function Widget:new(obj)
	obj = obj or {}
	obj.panes = {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Widget:batch(batch)
	for i, pane in ipairs(self.panes) do
		batch:add(
			pane.quad,
			self.x + pane.x_offset,
			self.y + pane.y_offset,
			0,
			pane.mid_scale_x or 1,
			pane.mid_scale_y or 1
		)
	end
end

--Button
local Panel = Widget:new({
	panel_name = "panel_brown_dark_corners_bimg.png",
	corner_size = 30,
	width = 80,
	height = 80
})

local function make_quads_from_size(name, size)
	local x, y, w, h = UI_Renderer.quads[name]:getViewport()
	local tw, th = UI_Renderer.quads[name]:getTextureDimensions()
	return {
		{
			love.graphics.newQuad(x, y, size, size, tw, th),
			love.graphics.newQuad(x+size, y, w-2*size, size, tw, th),
			love.graphics.newQuad(x+w-size, y, size, size, tw, th),
		},{
			love.graphics.newQuad(x, y+size, size, h-2*size, tw, th),
			love.graphics.newQuad(x+size, y+size, w-2*size, h-2*size, tw, th),
			love.graphics.newQuad(x+w-size, y+size, size, h-2*size, tw, th),
		},{
			love.graphics.newQuad(x, y+h-size, size, size, tw,th),
			love.graphics.newQuad(x+size, y+h-size, w-2*size, size, tw, th),
			love.graphics.newQuad(x+w-size, y+h-size, size, size, tw, th)
		}
	}
end

function Panel:new(obj)
	obj = Widget.new(self, obj)
	obj.panes = {}
	local quads = make_quads_from_size(obj.panel_name, obj.corner_size)
	local function make_offsets(dimension)
		return {
			0,
			obj.corner_size,
			dimension - obj.corner_size
		}
	end
	local _,_,mid_quad_width,mid_quad_height  = quads[2][2]:getViewport()
	local mid_scale_x = (obj.width - 2*obj.corner_size)/mid_quad_width
	local mid_scale_y = (obj.height - 2*obj.corner_size)/mid_quad_height
	local x_offsets = make_offsets(obj.width)
	local y_offsets = make_offsets(obj.height)
	for i, row in ipairs(quads) do
		for j, quad in ipairs(row) do
			table.insert(obj.panes, {
				quad = quad,
				x_offset = x_offsets[j],
				y_offset = y_offsets[i],
				mid_scale_x = j == 2 and mid_scale_x or 1,
				mid_scale_y = i == 2 and mid_scale_y or 1,
			})
		end
	end
	return obj
end

return {
	UI_Renderer = UI_Renderer,
	Widget = Widget,
	Panel = Panel,
}
