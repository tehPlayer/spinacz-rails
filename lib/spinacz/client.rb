module Spinacz
  class Client
    attr_accessor :email, :password, :token, :test

    URL = 'https://spinacz.pl'
    TEST_URL = 'https://test.spinacz.pl'

    def initialize(credentials = {})
      @email = credentials[:email] || ENV['SPINACZ_EMAIL']
      @email = @email.strip if @email
      @password = credentials[:password] || ENV['SPINACZ_PASSWORD']
      @password = @password.strip if @password
      @token = credentials[:token] || ENV['SPINACZ_TOKEN']
      @token = @token.strip if @token
      @test = credentials[:test]
    end

    def login
      check_credentials
    end

    def add_package_DHL(package = {})
      check_credentials
      call_api(:post, 'addPackageDHL', package)
    end

    def add_package_DPD(package = {})
      check_credentials
      call_api(:post, 'addPackageDPD', package)
    end

    def add_package_FEDEX(package = {})
      check_credentials
      call_api(:post, 'addPackageFEDEX', package)
    end

    def add_package_GLS(package = {})
      check_credentials
      call_api(:post, 'addPackageGLS', package)
    end

    def add_package_INPOST(package = {})
      check_credentials
      call_api(:post, 'addPackageINPOST', package)
    end

    def add_package_KEX(package = {})
      check_credentials
      call_api(:post, 'addPackageKEX', package)
    end

    def add_package_POCZTA(package = {})
      check_credentials
      call_api(:post, 'addPackagePOCZTA', package)
    end

    def add_package_UPS(package = {})
      check_credentials
      call_api(:post, 'addPackageUPS', package)
    end

    def cancel(query = {})
      check_credentials
      call_api(:get, 'cancel', query)
    end

    def get_packages_templates
      check_credentials
      call_api(:get, 'getPackagesTemplates')
    end

    def get_paczkomaty(query = {})
      call_api(:get, 'getPaczkomaty', query)
    end

    def get_placowki(query = {})
      call_api(:get, 'getPlacowki', query)
    end

    def get_send_points
      check_credentials
      call_api(:get, 'getSendPoints')
    end

    def pickup(query = {})
      check_credentials
      call_api(:get, 'pickup', query)
    end

    protected
      def call_api(call_type, get_data, json_data = nil)
        json_data_converted = json_data ? json_data.to_json : ''
        endpoint = "/api/v1/#{get_data}"
        url = @test ? TEST_URL : URL

        conn = Faraday.new(url: url) do |faraday|
          faraday.request  :url_encoded
          # faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end

        response = conn.send(call_type) do |req|
          if call_type == :get 
            req.url endpoint, json_data
          else
            req.url endpoint
            req.body = json_data_converted
          end

          # req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = @token if @token.present?
        end

        body = JSON.parse(response.body)

        if body['error'].nil?
          body['success']
        else
          raise Spinacz::ParametersInvalidError, "Wrong parameters provided. Full error response: #{body['error']}"
        end
      end

      def check_credentials
        unless (@password.present? and @email.present?) or @token.present?
          raise Spinacz::CredentialsMissingError, 'Email with password or token are missing.'
        end

        unless @token.present?
          authorization = call_api(:get, 'login', {email: @email, password: Digest::SHA256.hexdigest(@password)})

          if authorization['hash'].present?
            @token = authorization['hash'] 
          else
            raise Spinacz::CredentialsInvalidError, 'email or password is invalid'
          end
        end
      end
  end
end
