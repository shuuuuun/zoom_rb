# frozen_string_literal: true

module Zoom
  class Client
    class OAuth < Zoom::Client
      attr_reader :auth_token, :access_token, :refresh_token

      # Auth_token is sent in the header
      # (auth_code, auth_token, redirect_uri) -> oauth API
      # Returns (access_token, refresh_token)
      #
      # (auth_token, refresh_token) -> oauth refresh API
      # Returns (access_token, refresh_token)
      #
      def initialize(config)
        Zoom::Params.new(config).permit(:auth_token, :auth_code, :redirect_uri, :access_token, :refresh_token, :timeout)
        Zoom::Params.new(config).require_one_of(:access_token, :refresh_token, :auth_token)
        if (config.keys & [:auth_token, :auth_code, :redirect_uri]).any?
          Zoom::Params.new(config).require(:auth_token, :auth_code, :redirect_uri)
        end

        config.each { |k, v| instance_variable_set("@#{k}", v) }
        self.class.default_timeout(@timeout || 20)
      end

      def auth
        refresh_token ? refresh : oauth
      end

      def refresh
        response = refresh_tokens(refresh_token: @refresh_token)
        set_tokens(response)
        response
      end

      def oauth
        response = access_tokens(auth_code: @auth_code, redirect_uri: @redirect_uri)
        set_tokens(response)
        response
      end

      private

      def set_tokens(response)
        if response.is_a?(Hash) && !response.key?(:error)
          @access_token = response["access_token"]
          @refresh_token = response["refresh_token"]
        end
      end
    end
  end
end
