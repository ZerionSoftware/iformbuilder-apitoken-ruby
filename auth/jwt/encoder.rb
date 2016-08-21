require 'json'
require 'base64'

module Iform
	module Encoder
		def encode_json(raw_input)
			# JSON.generate will only hanle hashes / arrays
			raw_input.to_json
		end

		def decode_json(json)
			JSON.parse(json)
		end

		# standard replacments for url safe encoding
		def base64url_encode(input)
			Base64.encode64(input).tr('+/', '-_').gsub(/[\n=]/, '')
		end

		# adjust for 24 bit strings
		def base64url_decode(str)
			str += '=' * (4 - str.length.modulo(4))
			Base64.decode64(str.tr('-_', '+/'))
		end
	end
end
