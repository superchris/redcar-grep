require 'grep/grep_command'
require 'grep/grep_controller'
Dir.glob(File.dirname(__FILE__) + "/../vendor/*").each do |path|
  gem_name = File.basename(path.gsub(/-[\d\.]+$/, ''))
  $LOAD_PATH << path + "/lib/"
end

require 'rake' rescue nil

module Redcar
  
  module Grep
    
    # This class is your plugin. Try adding new commands in here
    # and putting them in the menus.
    class Plugin
      def self.menus
        Redcar::Menu::Builder.build do
          sub_menu "Edit" do
            sub_menu "Find", :priority => 50 do
              item "Grep", GrepCommand
            end
            separator
          end
        end
      end
      
      def self.project_context_menus(tree, node, controller)
        Menu::Builder.build do
          if node and node.path
            item ("Grep"){GrepCommand.new(node.path).run }
          end
        end
      end
      
      def self.keymaps
        osx = Redcar::Keymap.build("main", :osx) do
          link "Cmd+Alt+S", GrepCommand
        end
        
        [osx]
      end
    end
  end
end