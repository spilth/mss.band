import React from 'react';
import ReactDOM from 'react-dom';

class SongRow extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return <tr>
      <td><a href={'/songs/' + this.props.song.songpro}>{this.props.song.title}</a></td>
      <td>{this.props.song.artist}</td>
      <td>{SongRow.difficultyLabel(this.props.song.difficulty)}</td>
      <td>
        <a href={'/pdfs/' + this.props.song.songpro + '.pdf'}>
          <span className="d-none d-md-inline">Download</span>
          <i className="d-md-none fas fa-file-pdf fa-fw"/>
        </a>
      </td>
      <td>
        <a href={this.props.song.listen}>
          <span className="d-none d-md-inline">Listen</span>
          <i className="d-md-none fas fa-play fa-fw"/>
        </a>
      </td>
    </tr>;
  }

  static difficultyLabel(difficulty) {
    switch (difficulty) {
      case 1:
        return <span className="badge badge-success">Easy</span>;
      case 2:
        return <span className="badge badge-warning">Medium</span>;
    }
  }
}

class SongTable extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            error: null,
            isLoaded: false,
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            difficultyClassName: 'sortable',
            songs: [],
        };

        this.sortByArtist = this.sortByArtist.bind(this);
        this.sortByTitle = this.sortByTitle.bind(this);
        this.sortByDifficulty = this.sortByDifficulty.bind(this);
    }

    componentDidMount() {
        fetch('/songs.json')
            .then(res => res.json())
            .then(
                (result) => {
                    this.setState({
                      isLoaded: true,
                      titleClassName: 'sortable asc',
                      artistClassName: 'sortable',
                      difficultyClassName: 'sortable',
                      songs: result.songs
                    });
                },
                (error) => {
                    console.log(error);
                    this.setState({
                        isLoaded: true,
                        error
                    });
                }
            )
    }

    sortByTitle() {
        this.setState({
          titleClassName: 'sortable asc',
          artistClassName: 'sortable',
          difficultyClassName: 'sortable',
          songs: this.state.songs.sort(function (a, b) {
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
                return 0;
            })
        })
    };

    sortByArtist() {
        this.setState({
          titleClassName: 'sortable',
          artistClassName: 'sortable asc',
          difficultyClassName: 'sortable',
          songs: this.state.songs.sort(function (a, b) {
                if (a.artist < b.artist) return -1;
                if (a.artist > b.artist) return 1;

                // Sort songs by the same artist alphabetically
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
            })
        })
    };

    sortByDifficulty() {
      this.setState({
        titleClassName: 'sortable',
        artistClassName: 'sortable',
        difficultyClassName: 'sortable asc',
        songs: this.state.songs.sort(function (a, b) {
          if (a.difficulty < b.difficulty) return -1;
          if (a.difficulty > b.difficulty) return 1;

          // Sort songs by the same artist alphabetically
          if (a.title < b.title) return -1;
          if (a.title > b.title) return 1;
        })
      })
    };

    render() {
        return (
            <table className="table table-hover">
                <thead>
                <tr>
                    <th className={this.state.titleClassName} onClick={this.sortByTitle}>
                      Title
                    </th>
                    <th className={this.state.artistClassName} onClick={this.sortByArtist}>
                      Artist
                    </th>
                    <th className={this.state.difficultyClassName} onClick={this.sortByDifficulty}>
                      <span className="d-none d-lg-inline">Difficulty</span>
                      <i className="d-lg-none fas fa-signal fa-fw"/>
                    </th>
                    <th>
                        <span className="d-none d-md-inline">Download</span>
                        <i className="d-md-none fas fa-file-pdf fa-fw"/>
                    </th>
                    <th>
                        <span className="d-none d-md-inline">Listen</span>
                        <i className="d-md-none fas fa-play fa-fw"/>
                    </th>
                </tr>
                </thead>
                <tbody>
                  {this.state.songs.map((song) => <SongRow key={song.title} song={song} />)}
                </tbody>
            </table>
        )
    }
}

ReactDOM.render(<SongTable/>, document.getElementById('song-table'));
