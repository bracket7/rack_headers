module Rack
  module Headers
    class Print

      attr_accessor :request_headers
      attr_accessor :response_headers
      attr_accessor :logger

      def initialize(app)

        @app = app
        yield self if block_given?

        # Defaults
        self.request_headers ||= ['If-Modified-Since']
        self.response_headers ||= ['Last-Modified']
        self.logger ||= Rails.configuration.logger if defined?(Rails)
      end

      def call(env)
        output(request_headers, env)
        status, headers, response = @app.call(env)
        output(response_headers, headers)
        [status, headers, response]
      end

      private

      def output(keys, headers)
        logger.info keys.collect do |key|
          "#{key}: #{headers[key.to_s]}"
        end.join(', ')
      end
    end
  end
end # Warden
