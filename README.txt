This tool converts scala files (.scl) to 0CC famitracker detune settings (.csv).
You can download scala here to generate scl files: http://www.huygens-fokker.org/scala/downloads.html
You can also just edit/make scala files in notepad. Take a look at the examples to figure out how it works.

The .csv files can be imported in 0CC via Module> Detune settings...> Import
I have included some examples to get you started.

Usage:
 Just drag and drop scala file into the program.
 You can change the amount of N163 channels via the number keys 1-8.
 The output files should appear in the same folder as the .exe.

Some caveats:
- The tuning center is C3, as notated in famitracker. (around 130.8 Hz)
  This means that some channels will be an octave off.
  For example: the 2A03 pulse channels are an octave too high, FDS is one octave too low.
  
- While non-octave repeating scales, or scales with a different number of notes than 12 per octave
  are supported, this doesn't work with VRC7.

- Pitches in the scala file should be either ratios of whole numbers, or real numbers expressed in cents.
  Do not add anything else on these lines. Lines starting with '!' will be ignored.
