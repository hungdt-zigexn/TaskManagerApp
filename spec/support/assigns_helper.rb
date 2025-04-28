module AssignsHelper
  def assigns(key)
    @controller.instance_variable_get("@#{key}")
  end
end

RSpec.configure do |config|
  config.include AssignsHelper, type: :request
end
