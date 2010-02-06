module FSSM::Backends
  class Inotify
    def initialize
      @notifier = INotify::Notifier.new
    end

    def add_handler(handler, preload=true)
      @notifier.watch(handler.path.to_s, :attrib, :modify, :create,
        :delete, :delete_self, :moved_from, :moved_to, :move_self) do |event|
        handler.refresh(FSSM::Pathname.for(event.name))
      end

      handler.refresh(nil, true) if preload
    end

    def run
      begin
        @notifier.run
      rescue Interrupt
      end
    end

  end
end
