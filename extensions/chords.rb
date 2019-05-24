class Chords < Middleman::Extension
  expose_to_template :chord_svg

  def chord_svg(name, fingerings = nil)
    ChordDiagrams.chord_svg(name, fingerings)
  end
end

::Middleman::Extensions.register(:chords, Chords)
