# Rubysounds
Ruby library to manage sounds using Google Translate &amp; command line VLC.

## How do I get set up? ##

You need to install VLC (https://www.videolan.org/vlc/index.it.html)
NOTE: If you are using Windows remember to add the VLC path to your Environment Variables

## Example usage ##

```ruby
load "speech.rb"
beep(600, 200)
speak('Hello Ruby')
```

## Credits ##

Thanks to rudkovskyi (https://github.com/rudkovskyi/txt2speech) for the Txt2Speech module which converts text to speech using Google Translate API.
