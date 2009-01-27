dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << dir unless $LOAD_PATH.include?(dir)
require 'classy_resources/mime_type'

module ClassyResources
  def class_for(resource)
    resource.to_s.singularize.classify.constantize
  end

  def load_collection(resource)
    class_for(resource).all
  end

  def define_resource(*options)
    ResourceBuilder.new(self, *options)
  end

  def collection_url_for(resource, format)
    "/#{resource}.#{format}" 
  end

  def object_url_for(resource, format, object)
    "/#{resource}/#{object.id}.#{format}"
  end

  def set_content_type(format)
    content_type Mime.const_get(format.to_s.upcase).to_s
  end

  def create_object(resource, params)
    class_for(resource).create!(params)
  end

  class ResourceBuilder
    attr_reader :resources, :options, :main, :formats

    def initialize(main, *options)
      @main      = main
      @options   = options.pop if options.last.is_a?(Hash)
      @resources = options
      @formats   = :xml

      build!
    end

    def build!
      resources.each do |r|
        [*formats].each do |f|
          [*options[:collection]].each do |m|
            define_collection(m, r, f)
          end
        end
      end
    end

    protected
      def define_collection(method, resource, format)
        send(:"define_collection_#{method}", resource, format)
      end

      def define_collection_get(resource, format)
        get collection_url_for(resource, format) do
          set_content_type(format)
          load_collection(resource).send(:"to_#{format}")
        end
      end
      
      def define_collection_post(resource, format)
        post collection_url_for(resource, format) do
          set_content_type(format)
          object = create_object(resource, params[resource.to_s.singularize])
          redirect object_url_for(resource, format, object)
        end
      end
  end
end

include ClassyResources

