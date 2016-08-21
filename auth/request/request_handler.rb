require "net/http"
require "uri"
require "cgi"
require 'openssl'

module Iform
  class RequestHandler

    VERBS = {
      :get    => Net::HTTP::Get,
      :post   => Net::HTTP::Post,
      :put    => Net::HTTP::Put,
      :delete => Net::HTTP::Delete
    }

    def initialize path
      uri = URI.parse(path)
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true
    end

    #get resource
    def get path, params = nil
      _request :get, path, params
    end

    #post internal resource
    def post path, params = nil
      _request :post, path, params
    end

    #delete internal resource
    def delete path
      _request :delete, path, params
    end

    #put internal resource
    def put path, params = nil
      _request :put, path, params
    end

    def _url_encode url, params
      [url, URI.encode_www_form(params)].join("?")
    end

    def _request method, path, params = nil

      if method == :get
        path = _url_encode path, params unless params.nil?
        request_obj = VERBS[method.to_sym].new(path)
      else
        request_obj = VERBS[method.to_sym].new(path)
        request_obj.set_form_data(params)
      end

      @http.request request_obj
    end

    private

    def http uri
      if ! uri.instance_of? URI::HTTP
        raise Error 'uri must be URI::HTTP instance'
      end

      @htpp ||= Net::HTTP.new(uri.host, uri.port)
    end
  end
end
