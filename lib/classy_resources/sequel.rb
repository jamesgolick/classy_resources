module ClassyResources
  module Sequel
    def load_shallow_collection(resource)
      class_for(resource).all
    end

    def load_nested_collection(resource, parent)
      load_object(parent, params[parent_id_name(parent)]).send(resource)
    end

    def create_object(resource, params, parent)
      class_for(resource).create(params)
    end

    def load_object(resource, id)
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
