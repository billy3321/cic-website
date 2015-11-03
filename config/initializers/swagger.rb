class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "/apidocs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # :controller_base_path => 'api',
    # the output location where your .json files are written to
    :api_file_path => "public/apidocs",
    # the URL base path to your API
    :base_path => "#{Setting.url.protocol}://#{Setting.url.host}/",
    # if you want to delete all .json files at each generation
    :clean_directory => true,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "民間司改會數位典藏",
        "description" => "民間司改會數位典藏 API",
        "contact" => "contact@jrf.org.tw",
        "license" => "MIT"
      }
    }
  }
})