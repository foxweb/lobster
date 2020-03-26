module Services
  class EventLogger < BaseAmqp
    EXCHANGE = ENV.fetch('APP_BPM_EXCHANGE', 'services').freeze

    def send_event(request_id, message, event)
      publish_message(request_id, message, event)
    end

  private
    def publish_message(request_id, message, event)
      payload = payload_json(request_id, message, event)
      Rails.logger.info(
        "Send to EventLogger - routing_key: #{routing_key}; message: #{payload}"
      )
      exchange = find_exchange(EXCHANGE)
      exchange.publish(payload.to_json, routing_key: routing_key)
    end

    def payload_json(request_id, message, event)
      {
        params: {
          task_id:   request_id,
          event:     event,
          timestamp: Time.current,
          message:   message
        }
      }
    end

    def routing_key
      ENV.fetch('APP_EVENT_LOGGER_ROUTING_KEY', 'event_logger_in')
    end
  end
end
