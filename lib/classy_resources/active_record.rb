module ClassyResources
  module ActiveRecord
    def load_collection(resource, parent = nil)
      parent.nil? ? load_shallow_collection(resource) : load_nested_collection(resource, parent)
    end

    def load_shallow_collection(resource)
      class_for(resource).all
    end

    def load_nested_collection(resource, parent)
      load_parent_object(parent).send(resource)
    end

    def load_parent_object(parent)
      load_object(parent, params[parent_id_name(parent)])
    end

    def create_object(resource, params, parent = nil)
      parent.nil? ? create_shallow_object(resource, params) : create_nested_object(resource, params, parent)
    end

    def create_shallow_object(resource, params)
      class_for(resource).create!(params)
    end

    def create_nested_object(resource, params, parent)
      load_parent_object(parent).send(resource).create!(params)
    end

    def load_object(resource, id)
      class_for(resource).find(id)
    end

    def update_object(object, params)
      object.update_attributes(params)
    end

    def destroy_object(object)
      object.destroy
    end
  end
end

include ClassyResources::ActiveRecord

