local self = {}

function self.set(music)
  self.current = music
  return self.current
end

function self.get()
  return self.current
  end

return self