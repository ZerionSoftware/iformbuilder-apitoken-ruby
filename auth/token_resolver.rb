require './auth/jwt/encoder.rb'
require "./auth/jwt/jwt.rb"
require "./auth/request/request_handler.rb"

module Iform
  class TokenResolver
    include Iform::Encoder
    attr_accessor :encode, :request

    OAUTH = '/exzact/api/oauth/token'

    def get_token url, client, secert
      request url, params(client, secert, url)
    end

    private

    def params client, secert, url
      {
        grant_type:'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion:sign_assertion(client, secert, url)
      }
    end

    def valid_url url
      url.empty?
    end

    def validate res
      response = decode_json(res.body)
      response.has_key?("access_token") ? response["access_token"] : response["error"]
    end

    def sign_assertion client, secret, endpoint
      iat = time = Time.now.to_i
      payload = {
        'iss' => client,
        'aud' => endpoint + OAUTH,
        'exp' => iat + 600,
        'iat' => iat
      }

      encode_jwt payload, secret
    end

    def encode_jwt payload, secret
      @encode ||= Iform::JWT.new
      @encode.encode payload, secret
    end

    def request url, params
      @request ||= Iform::RequestHandler.new url
      validate @request.post OAUTH, params
    end
  end
end
