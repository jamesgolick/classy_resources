module ClassyResources
  module Sequel
    def load_collection(resources)
      class_for(resources).all
    end

    def create_object(resource, params)
      class_for(resource).create(params)
    end

    def find_object(resource, id)
      class_for(resource).find(:id => id)
    end

    def update_object(object, params)
      object.update(params)
    end

    def destroy_object(object)
      object.destroy
    end
  end
end

include ClassyResources::Sequel
