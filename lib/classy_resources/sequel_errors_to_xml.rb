# stolen from active record
#
module ClassyResources
  module SequelErrorsToXml
    def to_xml(options={})
      options[:root] ||= "errors"
      options[:indent] ||= 2
      options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])

      options[:builder].instruct! unless options.delete(:skip_instruct)
      options[:builder].errors do |e|
        full_messages.each { |msg| e.error(msg) }
      end
    end
  end

  ::Sequel::Model::Validation::Errors.send(:include, SequelErrorsToXml)
end

