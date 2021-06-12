require 'pdfkit'
require 'fileutils'
require 'combine_pdf'

class PdfGenerator < Middleman::Extension
  SITE_URL = 'https://mss.band/'.freeze
  PDF_BUILD_PATH = 'build/pdfs'.freeze
  TIMESTAMP = Time.new.strftime("%Y%m%d.%H%M").freeze

  COMMON_PDF_OPTIONS = {
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
    footer_font_size: 9,
    footer_left: TIMESTAMP,
    footer_right: SITE_URL
  }.freeze

  TOC_PDF_OPTIONS = {
    footer_center: "Table of Contents",
  }.freeze

  NUMBERING_FORMAT = {
    number_format: '%s',
    location: :bottom_right,
    margin_from_height: 5,
    font_size: 9
  }.freeze

  SONGS = Dir.glob('source/songs/*.html.sng').sort.collect do |filename|
    song = SongPro.parse(File.read(filename))
    {
      title: song.title,
      artist: song.artist,
      difficulty: song.custom[:difficulty],
      filename: song.title.parameterize,
      short: song.custom[:short],
      order: song.custom[:order],
    }
  end.select! do |song|
    song[:order]
  end.sort_by! { |song| song[:order].to_i }.freeze

  def manipulate_resource_list(resources)
    FileUtils::mkdir_p(PDF_BUILD_PATH)

    add_pdf_file_to_resource_list("mss-guitar.pdf", resources)
    add_pdf_file_to_resource_list("mss-ukulele.pdf", resources)

    add_song_pdfs_to_resource_list(resources)

    resources
  end

  def after_build(builder)
    FileUtils::mkdir_p(PDF_BUILD_PATH)

    generate_static_pdf("toc.pdf", TOC_PDF_OPTIONS, 'build/songbook/toc/index.html')
    generate_static_pdf("blank.pdf", COMMON_PDF_OPTIONS, 'build/songbook/blank_page/index.html')

    generate_song_pdfs

    generate_songbook_pdf("guitar")
    generate_songbook_pdf("ukulele")
  end

  private

  def add_song_pdfs_to_resource_list(resources)
    SONGS.each do |song|
      add_pdf_file_to_resource_list("#{song[:filename]}-guitar.pdf", resources)
      add_pdf_file_to_resource_list("#{song[:filename]}-ukulele.pdf", resources)
    end
  end

  def add_pdf_file_to_resource_list(filename, resources)
    song_path = "pdfs/#{filename}"
    song_source = "#{__dir__}/#{PDF_BUILD_PATH}/#{filename}"

    FileUtils.touch(song_source)
    resources << Middleman::Sitemap::Resource.new(@app.sitemap, song_path, song_source)
  end

  def generate_static_pdf(filename, options, source_path)
    html = File.open(source_path, 'rb').read
    pdf = PDFKit.new(
      html,
      COMMON_PDF_OPTIONS.merge(options)
    )
    pdf.to_file("#{PDF_BUILD_PATH}/#{filename}")
  end

  def generate_song_pdfs
    SONGS.each do |song|
      generate_song_pdf("#{song[:filename]}/guitar/index.html", "#{song[:filename]}-guitar.pdf", song)
      generate_song_pdf("#{song[:filename]}/ukulele/index.html", "#{song[:filename]}-ukulele.pdf", song)
    end
  end

  def generate_song_pdf(source_filename, target_filename, song)
    html_path = "build/songs/#{source_filename}"
    pdf_path = "#{PDF_BUILD_PATH}/#{target_filename}"

    if pdf_up_to_date(html_path, pdf_path)
      puts "Skipping #{pdf_path} - already up to date"
    else
      puts "Generating #{pdf_path}"

      html = File.open(html_path, 'rb').read
      pdf = PDFKit.new(
        html,
        COMMON_PDF_OPTIONS.merge(
          footer_center: "#{song[:title]}"
        )
      )

      pdf.stylesheets << Dir.glob('build/stylesheets/*.css')[0]
      pdf.to_file(pdf_path)
    end
  end

  def pdf_up_to_date(html_path, pdf_path)
    File.file?(pdf_path) && (File.mtime(pdf_path) > File.mtime(html_path))
  end

  def generate_songbook_pdf(instrument)
    songbook_pdf = CombinePDF.new
    songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/toc.pdf")

    SONGS.each do |song|
      songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/#{song[:filename]}-#{instrument}.pdf")
      songbook_pdf << CombinePDF.load("#{__dir__}/#{PDF_BUILD_PATH}/blank.pdf") if song[:short]
    end

    songbook_pdf.number_pages(NUMBERING_FORMAT)
    songbook_pdf.save("#{__dir__}/#{PDF_BUILD_PATH}/mss-#{instrument}.pdf")
  end
end

::Middleman::Extensions.register(:pdf_generator, PdfGenerator)
