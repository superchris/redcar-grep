module Redcar
  module Grep
    class GrepCommand < EditTabCommand
      
      def initialize(path=Project::Manager.focussed_project.path)
        @path = path
      end
      
      def execute
        window = Redcar.app.focussed_window
        tab = window.new_tab(HtmlTab)
        tab.html_view.controller = GrepController.new(@path)
        tab.focus
      end
    end
  end
end