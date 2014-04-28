local FacadeTestVO = class('FacadeTestVO')

function FacadeTestVO:ctor(input)
	self.input = input
	self.result = 0
end

return FacadeTestVO