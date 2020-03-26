module Services
  class BaseAmqp
    EXCHANGE = ENV.fetch('APP_BPM_EXCHANGE', 'services').freeze

  private
    def find_exchange(name)
      bunny_channel.exchange(name, passive: true)
    end

    def bunny_channel
      rabbit.channel
    end

    # def bunny_close!
    #   rabbit.close!
    # end

    # def bunny_connection
    #   rabbit.connection
    # end

    def rabbit
      RabbitConnectionManager
    end
  end
end
