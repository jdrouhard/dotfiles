function psgrep
  ps ax | grep --color=always $argv | grep -v --color=always grep
end
