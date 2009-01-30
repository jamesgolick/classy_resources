require 'classy_resources/sequel_errors_to_xml'

module ClassyResources
  module Sequel
    class ResourceNotFound < RuntimeError; end

    def load_collection(resource)
      class_for(resource).all
    end

    def create_object(resource, object_params)
      class_for(resource).create(object_params)
    end

    def load_object(resource, id)
      r = class_for(resource).find(:id => id)
      raise ResourceNotFound if r.nil?
      r
    end

    def update_object(object, params)
      object.update(params)
    end

    def destroy_object(object)
      object.destroy
    end

    error ResourceNotFound do
      response.status = 404
    end
  end
end

include ClassyResources::Sequel
