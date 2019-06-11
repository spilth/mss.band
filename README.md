# mss.nyc

[Middleman](https://middlemanapp.com/) web site for providing the lyrics and chords to songs using the [SongPro](https://github.com/spilth/song_pro) format.

## Project Setup

To set up the project, do the following:

```bash
$ git clone git@github.com:spilth/mss.nyc.git
$ cd mss.nyc
$ bundle
$ npm install
$ rake server
```

You can then view the site as <http://localhost:4567>

## PDF Generation

To build the PDF versions of all songs to the `build/pdfs` directory:

```bash
$ rake build
```

## Site Deployment

 To deploy the site to Netlify:

```bash
$ npm install netlify-cli -g
$ netlify login
$ rake deploy 
```

