## stickr 0.3.2
* Get logo.png by default even if other files in directory. 
  * Closes https://github.com/akgold/stickr/issues/3 with https://github.com/akgold/stickr/pull/4

## stickr 0.3.1
* CRAN release
* Remove `installed.packages` call, substantial performance improvement.

## stickr 0.3.2
* Soften default behavior if there are multiple stickers in repo. `logo.png` will always be fetched by default with a warning if there are other options. Previously this resulted in an error. 