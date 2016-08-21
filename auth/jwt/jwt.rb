require './auth/jwt/encoder.rb'
require 'openssl'

module Iform
  # JSON Web Token (JWT) is an open standard (RFC 7519) used by iFormBuilder
  # A JWT is composed of three parts: a header, a claim set, and a signature. The header and claim set are JSON objects.
  # These JSON objects are serialized to UTF-8 bytes, then encoded using the Base64url encoding.
  # This encoding provides resilience against encoding changes due to repeated encoding operations.
  # The header, claim set, and signature are concatenated together with a ‘.’ character.
  class JWT
    include Iform::Encoder
    #encode the payload and do signature
    def encode payload, key, alg = 'HS256'
      begin
        encoded = get_segments payload, key, alg
      rescue StandardError => e
        encoded = e.message
      end

      return encoded
    end

    private

    def get_segments payload, key, alg
      segments = []
      segments << encode_header(alg)
      segments << encode_claim_set(payload)
      segments << signature(segments, key, alg)
      segments.join(".")
    end

    def valid_algorithm alg
      %w(HS256 HS384 HS512).include? alg
    end

    def encode_header alg
      if ! valid_algorithm alg then raise StandardError "invalid Algorithm" end
      base64url_encode(encode_json({'typ' => 'JWT', 'alg' => alg}))
    end

    def encode_claim_set payload
      base64url_encode(encode_json(payload))
    end

    def sign msg, key, alg
      algorithm = OpenSSL::Digest.new(alg.sub('HS', 'sha'))
      OpenSSL::HMAC.digest(algorithm, key, msg)
    end

    def signature segments, key, alg
      signing_input = segments.join('.')
      signature = sign signing_input, key, alg
      base64url_encode signature
    end
  end
end
