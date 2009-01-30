dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << dir unless $LOAD_PATH.include?(dir)
require 'classy_resources/mime_type'
require 'classy_resources/post_body_params'

module ClassyResources
  def class_for(resource)
    resource.to_s.singularize.classify.constantize
  end

  def define_resource(*options)
    ResourceBuilder.new(self, *options)
  end

  def collection_url_for(resource, format)
    "/#{resource}.#{format}"
  end

  def object_route_url(resource, format)
    "/#{resource}/:id.#{format}"
  end

  def object_url_for(resource, format, object)
    "/#{resource}/#{object.id}.#{format}"
  end

  def set_content_type(format)
    content_type Mime.const_get(format.to_s.upcase).to_s
  end

  def serialize(object, format)
    object.send(:"to_#{format}")
  end

  class ResourceBuilder
    attr_reader :resources, :options, :main, :formats

    def initialize(main, *args)
      @main      = main
      @options   = args.pop if args.last.is_a?(Hash)
      @resources = args
      @formats   = options[:formats] || :xml

      build!
    end

    def build!
      resources.each do |r|
        [*formats].each do |f|
          [:member, :collection].each do |t|
            [*options[t]].each do |v|
              send(:"define_#{t}_#{v}", r, f) unless v.nil?
            end
          end
        end
      end
    end

    protected
      def define_collection_get(resource, format)
        get collection_url_for(resource, format) do
          set_content_type(format)
          serialize(load_collection(resource), format)
        end
      end
      
      def define_collection_post(resource, format)
        post collection_url_for(resource, format) do
          set_content_type(format)
          object = build_object(resource, params[resource.to_s.singularize] || {})

          if object.valid?
            object.save

            response['location'] = object_url_for(resource, format, object)
            response.status      = 201
            serialize(object, format)
          else
            response.status      = 422
            serialize(object.errors, format)
          end
        end
      end

      def define_member_get(resource, format)
        get object_route_url(resource, format) do
          set_content_type(format)
          object = load_object(resource, params[:id])
          serialize(object, format)
        end
      end

      def define_member_put(resource, format)
        put object_route_url(resource, format) do
          set_content_type(format)
          object = load_object(resource, params[:id])
          update_object(object, params[resource.to_s.singularize])

          if object.valid?
            object.save
            serialize(object, format)
          else
            response.status = 422
            serialize(object.errors, format)
          end
        end
      end

      def define_member_delete(resource, format)
        delete object_route_url(resource, format) do
          set_content_type(format)
          object = load_object(resource, params[:id])
          destroy_object(object)
          ""
        end
      end
  end
end

include ClassyResources

