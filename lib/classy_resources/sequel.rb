module ClassyResources
  module Sequel
    def load_collection(resources)
      class_for(resources).all
    end
  end
end

include ClassyResources::Sequel
