class << Fiber
  def root
    Thread.current.root_fiber
  end
end

class Fiber
  def root?
    self == Fiber.root
  end
  alias root_fiber? root?
end