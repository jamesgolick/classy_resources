module ClassyResources
  module Sequel
    def load_collection(resources)
      class_for(resources).all
    end

    def create_object(resource, params)
      class_for(resource).create(params)
    end
  end
end

include ClassyResources::Sequel
