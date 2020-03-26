class Rabbit
  def initialize(connection_settings = default_connection_settings)
    @connection = Bunny.new(connection_settings)
    connection.start
    @channel = connection.create_channel
  end

  def channel
    if connection.connected? && @channel.open?
      @channel
    else
      connection.stop && connection.start
      @channel = connection.create_channel
    end
  end

private
  attr_reader :connection

  def default_connection_settings
    {
      hosts:              ENV['APP_RABBITMQ_HOSTS'].split(','),
      vhost:              ENV['APP_RABBITMQ_VHOST'],
      user:               ENV['APP_RABBITMQ_USER'],
      password:           ENV['APP_RABBITMQ_PASSWORD'],
      heartbeat_interval: 20
    }
  end
end
