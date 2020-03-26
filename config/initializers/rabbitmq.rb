class RabbitConnectionManager
  class << self
    def channel
      reconnect unless connected? && active_channel&.open?
      active_channel
    end

    def close!
      active_channel&.close
      active_connection&.close
    end

  private
    attr_reader :active_connection, :active_channel

    def hosts
      Oj.load(ENV.fetch('APP_RABBITMQ_HOSTS_JSON', '["localhost"]'))
    end

    def connection_settings
      @connection_settings ||= {
        hosts:              hosts,
        vhost:              ENV.fetch('APP_RABBITMQ_VHOST', 'lobster'),
        user:               ENV.fetch('APP_RABBITMQ_USER', 'guest'),
        password:           ENV.fetch('APP_RABBITMQ_PASSWORD', 'guest'),
        heartbeat_interval: 20
      }
    end

    def establish_connection
      @active_connection = Bunny.new(connection_settings)
      active_connection.start
      @active_channel = active_connection.create_channel
    end

    def reconnect
      close!
      establish_connection
    end

    def connected?
      active_connection&.connected?
    end
  end
end
