(require 'base16-definitions
         (locate-file "base16-definitions.el" custom-theme-load-path
                      '("c" "")))

(create-base16-theme base16
                        base16-description (base16-color-definitions))
