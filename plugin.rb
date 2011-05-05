
Plugin.define do
  name    "grep"
  version "1.0"
  file    "lib", "grep_plugin"
  object  "Redcar::Grep::Plugin"
  dependencies "redcar", ">0"
end