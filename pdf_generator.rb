require 'pdfkit'
require 'fileutils'
require 'combine_pdf'

class PdfGenerator < Middleman::Extension
  PDF_BUILD_PATH = 'build/pdfs'

  SONGS = YAML.load_file('data/songs.yml').
      reject { |song| song['chordpro'].nil? }

  def manipulate_resource_list(resources)
    FileUtils::mkdir_p(PDF_BUILD_PATH)

    add_song_pdfs_to_resource_list(resources)
    add_songbook_pdf_to_resource_list(resources)

    resources
  end

  def after_build(builder)
    FileUtils::mkdir_p(PDF_BUILD_PATH)

    generate_blank_pdf
    generate_toc_pdf
    generate_song_pdfs
    generate_songbook_pdf
  end

  private

  def add_song_pdfs_to_resource_list(resources)
    SONGS.each { |song| add_song_pdf_to_resource_list(resources, song) }
  end

  def add_song_pdf_to_resource_list(resources, song)
    song_path = "pdfs/#{song['chordpro']}.pdf"
    song_source = "#{__dir__}/#{PDF_BUILD_PATH}/#{song['chordpro']}.pdf"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def add_songbook_pdf_to_resource_list(resources)
    song_path = "pdfs/songbook.pdf"
    song_source = "#{__dir__}/#{PDF_BUILD_PATH}/songbook.pdf"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def generate_toc_pdf
    html = File.open('build/songbook/toc/index.html', "rb").read
    pdf = PDFKit.new(
        html,
        page_size: 'Letter',
        margin_top: 10,
        margin_bottom: 10,
        margin_left: 20,
        margin_right: 20,
        print_media_type: true,
        dpi: 480
    )
    pdf.to_file("#{PDF_BUILD_PATH}/toc.pdf")
  end

  def generate_blank_pdf
    html = File.open('build/songbook/blank_page/index.html', "rb").read
    pdf = PDFKit.new(
        html,
        page_size: 'Letter',
        margin_top: 10,
        margin_bottom: 10,
        margin_left: 20,
        margin_right: 20,
        print_media_type: true,
        dpi: 480
    )
    pdf.to_file("#{PDF_BUILD_PATH}/blank.pdf")
  end

  def generate_song_pdfs
    SONGS.each { |song| generate_song_pdf(song) }
  end

  def generate_song_pdf(song)
    html_path = "build/songs/#{song['chordpro']}/index.html"
    pdf_path = "#{PDF_BUILD_PATH}/#{song['chordpro']}.pdf"
    html = File.open(html_path, "rb").read

    pdf = PDFKit.new(
        html,
        page_size: 'Letter',
        margin_top: 10,
        margin_bottom: 10,
        margin_left: 20,
        margin_right: 20,
        print_media_type: true,
        dpi: 480,
        header_right: "http://mss.nyc/songs/#{song['chordpro']}",
        header_font_size: 9,
        footer_center: "#{song['title']} by #{song['artist']}",
        footer_font_size: 9
    )

    pdf.stylesheets << "build/stylesheets/site.css"
    pdf.to_file(pdf_path)
  end

  def generate_songbook_pdf
    songbook_pdf = CombinePDF.new
    songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/toc.pdf")

    SONGS.each do |song|
      songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/#{song['chordpro']}.pdf")
      if song['short']
        songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/blank.pdf")
      end
    end

    songbook_pdf.number_pages(
        number_format: '%s',
        location: :bottom_right,
        margin_from_height: 5,
        font_size: 9
    )

    songbook_pdf.save("#{__dir__}/#{PDF_BUILD_PATH}/songbook.pdf")
  end
end

::Middleman::Extensions.register(:pdf_generator, PdfGenerator)
