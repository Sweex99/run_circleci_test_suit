require 'net/http'

class TriggerCircleCiJobsService
  BASIC_URL = 'https://circleci.com/api/v2/project/'
  CIRCLE_CI_AUTH_TYPE = 'Circle-Token'

  attr_reader :organization_name, :project_name, :vcs_slug, :type_authorization, :authorization_token, :additional_parameters

  def initialize(parameters)
    @organization_name     = parameters[:organization_name]
    @project_name          = parameters[:project_name]
    @vcs_slug              = parameters[:vcs_slug]
    @type_authorization    = parameters[:type_authorization]
    @authorization_token   = parameters[:authorization_token]
    @additional_parameters = parameters[:parameters]
  end

  def run_pipeline
    http.request(get_request).read_body
  end

  private

  def http
    http = ::Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def get_request
    request = ::Net::HTTP::Post.new(uri)
    request['content-type'] = 'application/json'
    request['authorization'] = 'Basic ' + authorization_token
    request['Circle-Token'] = authorization_token if type_authorization == CIRCLE_CI_AUTH_TYPE
    request.body = additional_params.to_s
    request
  end

  def uri
    URI(BASIC_URL + vcs_slug + '/' + organization_name + '/' + project_name + '/pipeline')
  end

  def additional_params
    Hash[*additional_parameters.values].reject { |_, v| v.blank? }
  end
end
