module RFPDF
  module TemplateHandlers
    class Base < ::ActionView::Template::Handlers::ERB
      
      def compile(template)
        src = "_rfpdf_compile_setup;" + super
      end
    end
  end
end


