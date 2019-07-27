require 'pdfkit'
require 'fileutils'
require 'combine_pdf'

class PdfGenerator < Middleman::Extension
  PDF_BUILD_PATH = 'build/pdfs'.freeze

  PDF_OPTIONS = {
    page_size: 'letter',
    margin_top: '10mm',
    margin_bottom: '10mm',
    margin_left: '20mm',
    margin_right: '20mm',
    print_media_type: true,
    lowquality: true,
    dpi: 62,
    zoom: 1.0,
    outline_depth: 1,
  }.freeze

  TIMESTAMP = Time.new.strftime("%y%m%d.%H%M")

  SONGS = Dir.glob('source/songs/*.html.sng').sort.collect do |filename|
    song = SongPro.parse(File.read(filename))
    {
        title: song.title,
        artist: song.artist,
        difficulty: song.custom[:difficulty],
        songpro: song.title.parameterize,
        short: song.custom[:short],
        ignore: song.custom[:ignore],
        order: song.custom[:order],

    }
  end.select! do |song|
    song[:order]
  end.sort_by! {|song| song[:order].to_i}

  def manipulate_resource_list(resources)
    FileUtils::mkdir_p(PDF_BUILD_PATH)

    add_guitar_pdf_to_resource_list(resources)
    add_ukulele_pdf_to_resource_list(resources)
    add_song_pdfs_to_resource_list(resources)

    resources
  end

  def after_build(builder)
    FileUtils::mkdir_p(PDF_BUILD_PATH)

    generate_blank_pdf
    generate_toc_pdf
    generate_song_pdfs

    generate_guitar_songbook_pdf
    generate_ukulele_songbook_pdf
  end

  private

  def add_song_pdfs_to_resource_list(resources)
    SONGS.each do |song|
      add_guitar_song_pdf_to_resource_list(resources, song)
      add_ukulele_song_pdf_to_resource_list(resources, song)
    end
  end

  def add_guitar_song_pdf_to_resource_list(resources, song)
    guitar_song_path = "pdfs/#{song[:songpro]}.pdf"
    guitar_song_source = "#{__dir__}/#{PDF_BUILD_PATH}/#{song[:songpro]}.pdf"

    FileUtils.touch(guitar_song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, guitar_song_path, guitar_song_source)
  end

  def add_ukulele_song_pdf_to_resource_list(resources, song)
    ukulele_song_path = "pdfs/#{song[:songpro]}-ukulele.pdf"
    ukulele_song_source = "#{__dir__}/#{PDF_BUILD_PATH}/#{song[:songpro]}-ukulele.pdf"

    FileUtils.touch(ukulele_song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, ukulele_song_path, ukulele_song_source)
  end

  def add_guitar_pdf_to_resource_list(resources)
    song_path = 'pdfs/mss-guitar.pdf'
    song_source = "#{__dir__}/#{PDF_BUILD_PATH}/mss-guitar.pdf"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def add_ukulele_pdf_to_resource_list(resources)
    song_path = 'pdfs/mss-ukulele.pdf'
    song_source = "#{__dir__}/#{PDF_BUILD_PATH}/mss-ukulele.pdf"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def generate_blank_pdf
    html = File.open('build/songbook/blank_page/index.html', 'rb').read
    pdf = PDFKit.new(
        html,
        PDF_OPTIONS.merge(
            footer_font_size: 9,
            footer_left: TIMESTAMP,
            footer_right: 'http://mss.nyc/',
            )
    )
    pdf.to_file("#{PDF_BUILD_PATH}/blank.pdf")
  end

  def generate_toc_pdf
    html = File.open('build/songbook/toc/index.html', 'rb').read
    pdf = PDFKit.new(
      html,
      PDF_OPTIONS.merge(
        footer_center: "Table of Contents",
        footer_font_size: 9,
        footer_left: TIMESTAMP,
        footer_right: 'http://mss.nyc/',
      )

    )
    pdf.to_file("#{PDF_BUILD_PATH}/toc.pdf")
  end

  def generate_song_pdfs
    SONGS.each do |song|
      generate_guitar_pdf(song)
      generate_ukulele_pdf(song)
    end
  end

  def generate_guitar_pdf(song)
    html_path = "build/songs/#{song[:songpro]}/index.html"
    pdf_path = "#{PDF_BUILD_PATH}/#{song[:songpro]}.pdf"
    html = File.open(html_path, 'rb').read

    generate_song_pdf(html, html_path, pdf_path, song)
  end

  def generate_ukulele_pdf(song)
    html_path = "build/songs/#{song[:songpro]}/ukulele/index.html"
    pdf_path = "#{PDF_BUILD_PATH}/#{song[:songpro]}-ukulele.pdf"
    html = File.open(html_path, 'rb').read

    generate_song_pdf(html, html_path, pdf_path, song)
  end

  def generate_song_pdf(html, html_path, pdf_path, song)
    if File.file?(pdf_path) && (File.mtime(pdf_path) > File.mtime(html_path))
      puts "Skipping #{pdf_path} - already up to date"
    else
      puts "Generating #{pdf_path}"

      pdf = PDFKit.new(
          html,
          PDF_OPTIONS.merge(
              footer_center: "#{song[:title]}",
              footer_font_size: 9,
              footer_left: TIMESTAMP,
              footer_right: 'http://mss.nyc/',
          )
      )

      hashed_stylesheet = Dir.glob('build/stylesheets/*.css')[0]
      pdf.stylesheets << hashed_stylesheet
      pdf.to_file(pdf_path)
    end
  end

  def generate_guitar_songbook_pdf
    songbook_pdf = CombinePDF.new
    songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/toc.pdf")

    SONGS.each do |song|
      songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/#{song[:songpro]}.pdf")
      if song[:short]
        songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/blank.pdf")
      end
    end

    songbook_pdf.number_pages(
      number_format: '%s',
      location: :bottom_right,
      margin_from_height: 5,
      font_size: 9
    )

    songbook_pdf.save("#{__dir__}/#{PDF_BUILD_PATH}/mss-guitar.pdf")
  end

  def generate_ukulele_songbook_pdf
    songbook_pdf = CombinePDF.new
    songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/toc.pdf")

    SONGS.each do |song|
      songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/#{song[:songpro]}-ukulele.pdf")
      if song[:short]
        songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/blank.pdf")
      end
    end

    songbook_pdf.number_pages(
        number_format: '%s',
        location: :bottom_right,
        margin_from_height: 5,
        font_size: 9
    )

    songbook_pdf.save("#{__dir__}/#{PDF_BUILD_PATH}/mss-ukulele.pdf")
  end
end

::Middleman::Extensions.register(:pdf_generator, PdfGenerator)
