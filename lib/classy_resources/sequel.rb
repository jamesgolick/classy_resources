module ClassyResources
  module Sequel
    def load_shallow_collection(resource)
      class_for(resource).all
    end

    def load_nested_collection(resource, parent)
      load_parent_object(parent).send(resource)
    end

    def create_shallow_object(resource, object_params)
      class_for(resource).create(object_params)
    end

    def create_nested_object(resource, object_params, parent)
      c = create_shallow_object(resource, object_params)
      load_parent_object(parent).send(:"add_#{resource.to_s.singularize}", c)
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
