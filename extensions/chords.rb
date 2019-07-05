class Chords < Middleman::Extension
  expose_to_template :guitar_svg, :ukulele_svg

  def guitar_svg(name, fingerings = nil)
    ChordDiagrams.guitar_svg(name, fingerings)
  end

  def ukulele_svg(name, fingerings = nil)
    ChordDiagrams.ukulele_svg(name, fingerings)
  end
end

::Middleman::Extensions.register(:chords, Chords)
