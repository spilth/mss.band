class Chords < Middleman::Extension
  expose_to_template :chord_svg, :tablature_svg

  def chord_svg(name, fingerings = nil)
    ChordDiagrams.chord_svg(name, fingerings)
  end

  def tablature_svg(tablature)
    Tablature.svg(tablature).render
  end
end

::Middleman::Extensions.register(:chords, Chords)
