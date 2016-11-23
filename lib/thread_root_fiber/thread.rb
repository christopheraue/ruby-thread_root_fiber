Thread.main.instance_eval{ @root_fiber = Fiber.current }

class << Thread
  %i(new start fork).each do |creator|
    alias_method :"__#{creator}_not_setting_root_fiber__", creator

    eval <<-CODE, __File__, __LINE__+1
      def #{creator}(*create_args)
        current_thread = Thread.current
        thread = __#{creator}_not_setting_root_fiber__(*create_args) do |*args|
          Thread.current.instance_eval{ @root_fiber = Fiber.current }
          current_thread.run
          yield *args
        end
        Thread.stop
        thread
      end
    CODE
  end
end

class Thread
  attr_reader :root_fiber
end