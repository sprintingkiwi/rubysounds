# Rubysounds
Ruby library to manage sounds using Google Translate &amp; command line VLC.

## How do I get set up? ##

You need to install VLC (https://www.videolan.org/vlc/index.it.html)
NOTE: If you are using Windows remember to add the VLC path to your Environment Variables

## Example usage ##

```ruby
# Import library
require 'rubysounds'

# Play audio or video file
play('path_to_file')

# Speak a string with Google voice
speak('Hello Ruby')

# Make a beep (only on Windows systems)
beep(600, 200)
```

## Credits ##

Thanks to rudkovskyi (https://github.com/rudkovskyi/txt2speech) for the Txt2Speech module which converts text to speech using Google Translate API.
