# mostly from https://developers.google.com/sheets/api/quickstart/ruby

require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module Wheelbarrow
  module Auth
    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "Gardeners' Query Time".freeze
    CREDENTIALS_PATH = "secrets/credentials.json".freeze
    TOKEN_PATH = "secrets/token.yaml".freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

    def self.authed_service
      @srvc ||= Google::Apis::SheetsV4::SheetsService.new
      @srvc.client_options.application_name = APPLICATION_NAME
      @srvc.authorization = self.authorize

      @srvc
    end

    def self.authorize
      client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      user_id = "default"
      credentials = authorizer.get_credentials user_id
      if credentials.nil?
        url = authorizer.get_authorization_url base_url: OOB_URI
        puts "Open the following URL in the browser and enter the " \
            "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end
  end
end