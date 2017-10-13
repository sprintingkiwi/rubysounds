require "net/http"
require "slave"

# Check actual OS
$operative_system = "other"
if Gem.win_platform?
	$operative_system = "win"
end

$winlib = false
# Import Windows-specific libraries
if $operative_system == "win"
	begin
		require "win32/sound"
		include Win32
		$winlib = true
	rescue LoadError
		#puts "win32-sound gem not installed"
		puts ""
	end
end

# Class for text-to-speech using Google Translate
class Speech
	GOOGLE_TRANSLATE_URL = "http://translate.google.com/translate_tts".freeze

	attr_accessor :text, :lang

	def initialize(text, lang = "en")
	  @text = text
	  @lang = lang
	end

	def self.load(file_path, lang = "en")
	  f = File.open(file_path)
	  new f.read.encode("UTF-16be", invalid: :replace, replace: "?").encode("UTF-8"), lang
	end

	def save(file_path)
	  uri = URI(GOOGLE_TRANSLATE_URL)

	  response = []

	  sentences = text.split(/[,.\r\n]/i)
	  sentences.reject!(&:empty?)
	  sentences.map! { |t| divide(t.strip) }.flatten!

	  sentences.each_with_index do |q, _idx|
		uri.query = URI.encode_www_form(
		  ie: "UTF-8",
		  q: q,
		  tl: lang,
		  total: sentences.length,
		  idx: 0,
		  textlen: q.length,
		  client: "tw-ob",
		  prev: "input"
		)

		res = Net::HTTP.get_response(uri)

		next unless res.is_a?(Net::HTTPSuccess)

		response << res.body.force_encoding(Encoding::UTF_8)
	  end

	  File.open(file_path, "wb") do |f|
		f.write response.join
		return f.path
	  end
	end

	private

	def divide(text)
	  return text if text.length < 150

	  attempts = text.length / 150.0
	  starts = 0
	  arr = []

	  attempts.ceil.times do
		ends = starts + 150
		arr << text[starts...ends]
		starts = ends
	  end

	  arr
	end
end


#########################################################


# Array to store VLC sound processes
$children_sounds = Array.new

# Catching CTRL-C Keyboard Interrupt signal
trap "SIGINT" do
	puts "Exiting"
	# Kill all children sounds	
	for child_sound in $children_sounds	
		puts child_sound.pid
		# Kill child process...
		#Process.kill("QUIT", child_sound.pid)
		if $operative_system == "win"
			system("Taskkill /PID " + child_sound.pid.to_s + " /F")
		else
			system("kill " + child_sound.pid.to_s)
		end
		# This prevents the process from becoming defunct
		#child_sound.close
	end	
	#exit 130
end


def vlcplay(target, wait: true, bg: false, dummy: true)

	# Play in background option
	vlccmd = "vlc "
	if bg	
		vlccmd += "-I null "
	end
	
	vlccmd += "--play-and-exit "
	
	if (bg == false) && (dummy == true)
		vlccmd += "--intf dummy "
	end
	
	
	io = IO.popen(vlccmd + target)
	$children_sounds.push(io)
	# Wait for the sound to end option
	if wait
		Process.wait(io.pid)
	end
	
	#system(vlccmd + target)
	#Thread.new { system(vlccmd + target) }
	
end


def speak(text, language: "en", wait: true, bg: true)
	Speech.new(text, language).save("temp.wav")
	vlcplay("temp.wav", wait: wait, bg: bg)
	File.delete("temp.wav")
end


def dub(text)
	puts(text)
	speak(text)
end


def play(path, wait: true, bg: true)
	vlcplay(path, wait: wait, bg: bg)
end


# Windows-specific methods
def beep(a, b)
	if $winlib
		if $operative_system == "win"
			Sound.beep(a, b)
		else
			dub("the beep method is only avaible on Windows operative system")
		end
	else
		dub("Beep is not avaible. You need to gem install win32-sounds")
	end
end


def ms_win_play(path)
	if $winlib
		Sound.play(path)
	else
		dub("Beep is not avaible. You need to gem install win32-sounds")
	end
end
