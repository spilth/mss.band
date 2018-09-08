# mss.nyc

[Middleman](https://middlemanapp.com/) web site for providing the lyrics and chords to songs using the [SongPro](https://github.com/spilth/song_pro) format.

## Setup

To set up the project, do the following:

```bash
$ git clone git@github.com:spilth/mss.nyc.git
$ cd mss.nyc
$ bundle
$ rake server
```

You can then view the site as <http://localhost:4567>

## Deployment

To deploy, first create an `.s3_sync` file with the following:

```text
aws_access_key_id: YOUR_ACCESS_KEY
aws_secret_access_key: YOUR_SECRET_ACCESS_KEY
```

Then run `rake deploy`
