import React from 'react';
import ReactDOM from 'react-dom';

class SongTable extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            error: null,
            isLoaded: false,
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            songs: [],
        };

        this.sortByArtist = this.sortByArtist.bind(this);
        this.sortByTitle = this.sortByTitle.bind(this);
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
          songs: this.state.songs.sort(function (a, b) {
                if (a.artist < b.artist) return -1;
                if (a.artist > b.artist) return 1;

                // Sort songs by the same artist alphabetically
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
            })
        })
    };

    render() {
        return (
            <table className="table">
                <thead>
                <tr>
                    <th className={this.state.titleClassName} onClick={this.sortByTitle}>Title</th>
                    <th className={this.state.artistClassName} onClick={this.sortByArtist}>Artist</th>
                    <th>
                        <span className="d-none d-md-inline">Download</span>
                        <i className="d-md-none fas fa-file-pdf fa-fw"></i>
                    </th>
                    <th>
                        <span className="d-none d-md-inline">Listen</span>
                        <i className="d-md-none fab fa-spotify fa-fw"></i>
                    </th>
                </tr>
                </thead>
                <tbody>
                {this.state.songs.map((song) => <tr key={song.title}>
                  <td><a href={'/songs/' + song.chordpro}>{song.title}</a></td>
                    <td>{song.artist}</td>
                    <td><a href={'/pdfs/' + song.chordpro + '.pdf'}>
                        <span className="d-none d-md-inline">Download</span>
                        <i className="d-md-none fas fa-file-pdf fa-fw"></i>
                    </a></td>
                    <td><a href={song.spotify}>
                        <span className="d-none d-md-inline">Listen</span>
                        <i className="d-md-none fab fa-spotify fa-fw"></i>
                    </a></td>
                </tr>)}
                </tbody>
            </table>
        )
    }
}

ReactDOM.render(<SongTable/>, document.getElementById('song-table'));
