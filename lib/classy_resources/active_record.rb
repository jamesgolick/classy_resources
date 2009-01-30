module ClassyResources
  module ActiveRecord
    def load_shallow_collection(resource)
      class_for(resource).all
    end

    def load_nested_collection(resource, parent)
      load_parent_object(parent).send(resource)
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

    error ::ActiveRecord::RecordNotFound do
      response.status = 404
    end
  end
end

include ClassyResources::ActiveRecord

