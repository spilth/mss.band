# mss.band [![Netlify Status](https://api.netlify.com/api/v1/badges/a4726d31-9d1f-4724-93c2-0760841fe664/deploy-status)](https://app.netlify.com/sites/mss-band/deploys)

[Middleman](https://middlemanapp.com/) web site for providing the lyrics and chords to songs using the [SongPro](https://github.com/spilth/song_pro) format.

## Project Setup

To set up the project, do the following:

```bash
$ git clone git@github.com:spilth/mss.band.git
$ cd mss.band
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

