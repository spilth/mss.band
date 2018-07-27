require 'pdfkit'
require 'fileutils'
require 'combine_pdf'

class PdfGenerator < Middleman::Extension
  SONGS_WITH_CHORDPRO_FILES = YAML.load_file('data/songs.yml').reject { |song| song['chordpro'].nil? }
  SONGS = SONGS_WITH_CHORDPRO_FILES.sort_by { |song| song['title'] }

  def manipulate_resource_list(resources)
    FileUtils::mkdir_p 'build/pdfs'

    add_song_pdfs_to_resource_list(resources)
    add_songbook_pdf_to_resource_list(resources)

    resources
  end

  def after_build(builder)
    FileUtils::mkdir_p 'build/pdfs'

    generate_blank_pdf
    generate_song_pdfs
    generate_songbook_pdf
  end

  private

  def generate_song_pdfs
    SONGS.each { |song| generate_song_pdf(song) }
  end

  def add_songbook_pdf_to_resource_list(resources)
    song_path = "pdfs/songbook.pdf"
    song_source = "#{__dir__}/build/pdfs/songbook.pdf"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def add_song_pdfs_to_resource_list(resources)
    SONGS.each { |song| add_song_pdf_to_resource_list(resources, song) }
  end

  def add_song_pdf_to_resource_list(resources, song)
    song_path = "pdfs/#{song['chordpro']}.pdf"
    song_source = "#{__dir__}/build/pdfs/#{song['chordpro']}.pdf"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def generate_blank_pdf
    file = File.open('build/blank_page/index.html', "rb")
    html = file.read
    kit = PDFKit.new(html,
                     page_size: 'Letter',
                     margin_top: 10,
                     margin_bottom: 10,
                     margin_left: 10,
                     margin_right: 10,
                     print_media_type: true,
                     dpi: 480
    )
    kit.to_file('build/pdfs/blank.pdf')
  end


  def generate_song_pdf(song)
    html_path = "build/songs/#{song['chordpro']}/index.html"
    pdf_path = "build/pdfs/#{song['chordpro']}.pdf"
    stylesheet_path = "build/stylesheets/site.css"

    file = File.open(html_path, "rb")
    html = file.read

    kit = PDFKit.new(
        html,
        page_size: 'Letter',
        margin_top: 10,
        margin_bottom: 10,
        margin_left: 10,
        margin_right: 10,
        print_media_type: true,
        dpi: 480,
        footer_center: "#{song['title']} by #{song['artist']}",
        footer_font_size: 9
    )

    kit.stylesheets << stylesheet_path
    kit.to_file(pdf_path)
  end

  def generate_songbook_pdf
    songbook_pdf = CombinePDF.new
    songbook_pdf << CombinePDF.load("#{__dir__}/build/pdfs/blank.pdf")

    SONGS.each do |song|
      songbook_pdf << CombinePDF.load("#{__dir__}/build/pdfs/#{song['chordpro']}.pdf")
      if song['short']
        songbook_pdf << CombinePDF.load("#{__dir__}/build/pdfs/blank.pdf")
      end
    end

    songbook_pdf.number_pages(
        number_format: '%s',
        location: :bottom_right,
        margin_from_height: 5,
        font_size: 9
    )

    songbook_pdf.save("#{__dir__}/build/pdfs/songbook.pdf")
  end
end

::Middleman::Extensions.register(:pdf_generator, PdfGenerator)
