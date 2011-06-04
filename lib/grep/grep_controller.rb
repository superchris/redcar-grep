module Redcar
  module Grep
    class GrepController
      EXTS = ["rb", "js", "coffee", "html", "xml", "erb"]
      include Redcar::HtmlController

      def initialize(path)
        @path = path
      end
      
      def stylesheet_link_tag(*files)
        files.map do |file|
          path = File.join(Redcar.root, %w(plugins runnables views) + [file.to_s + ".css"])
          url = "file://" + File.expand_path(path)
          %Q|<link href="#{url}" rel="stylesheet" type="text/css" />|
        end.join("\n")
      end
      
      def output_processor
        @output_processor ||= Redcar::Runnables::OutputProcessor.new
      end
      
      def title
        "Grep"
      end
      
      def index
        path = @path
        rhtml = ERB.new(File.read(File.join(File.dirname(__FILE__), "views", "index.html.erb")))
        rhtml.result(binding)
      end

      def open_file(file, line)
        Project::Manager.open_file(file)
        Redcar.app.focussed_window.focussed_notebook_tab.edit_view.document.scroll_to_line_at_middle(line.to_i)
      end
      
      def replace(path, query, replacement, extensions)
        files = FileList["#{path}/**/*{#{extensions}}"].egrep(/#{query}/).collect {|fn, count, line| fn }.uniq
        files.each do
          |file| Project::Manager.open_file(file)
          options = Redcar::DocumentSearch::QueryOptions.new
          Redcar::DocumentSearch::ReplaceAllCommand.new(query, replacement, options, false).execute
        end
      end
      
      def search(path, query, extensions)
        execute %{$("#search_results").empty();}
        FileList["#{path}/**/*{#{extensions}}"].egrep(/#{query}/) do |fn, count, line|
          result = "#{fn}:#{count}:#{line}"
          processed_result = output_processor.process(result, :no_newline_after_br => true)
          execute %{ $(#{processed_result.inspect}).appendTo("#search_results"); }
        end
      end
    end
  end
end