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
        self.logger ||= defined?(RAILS_DEFAULT_LOGGER) ? RAILS_DEFAULT_LOGGER : Logger.new(STDOUT)
      end

      def call(env)
        output(request_headers, env, '==> Request Headers: ')
        status, headers, response = @app.call(env)
        output(response_headers, headers, '<== Response Headers: ')
        logger.info("\n\n")
        [status, headers, response]
      end

      private

      def output(keys, headers, prefix = 'Print Headers: ')
        str = keys.collect do |key|
          headers.key?(key.to_s) ? "#{key}: \"#{headers[key.to_s]}\"" : nil
        end.compact.join(', ')
        logger.info "#{prefix}#{str}"
      end
    end
  end
end