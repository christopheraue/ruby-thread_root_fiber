Thread.main.instance_eval{ @root_fiber = Fiber.current }

class << Thread
  alias_method :__new_not_setting_root_fiber__, :new

  def new(*new_args)
    current_thread = Thread.current
    thread = __new_not_setting_root_fiber__(*new_args) do |*args|
      Thread.current.instance_eval{ @root_fiber = Fiber.current }
      current_thread.run
      yield *args
    end
    Thread.stop
    thread
  end
end

class Thread
  attr_reader :root_fiber
end