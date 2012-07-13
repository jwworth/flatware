module Flatware
  class Dispatcher
    DISPATCH_PORT = 'ipc://dispatch'

    class << self
      def dispatch
        @dispatch ||= Flatware.socket(ZMQ::REP).tap do |socket|
          socket.bind DISPATCH_PORT
        end
      end

      def dispatch!
        features = Cucumber.features

        fireable.until_fired dispatch do |request|
          feature = features.pop
          if feature
            dispatch.send feature
          else
            dispatch.send 'seppuku'
          end
        end
      end

      private

      def log(*args)
        Flatware.log *args
      end

      def fireable
        @fireable ||= Fireable.new
      end
    end
  end
end
