core = 7.x
api = 2

projects[drupal][type] = core
projects[drupal][version] = "7.19"

;------------------------------------------------------------------------------------------
; Include "rotary" git
projects[rotary][type] = profile
projects[rotary][download][type] = git
projects[rotary][download][url] = git://github.com/dwork/rotary.git
