import React from "react";
import {SongRow} from "./songRow";

export class SongTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      titleClassName: 'sortable',
      artistClassName: 'sortable',
      difficultyClassName: 'sortable',
      songs: [],
    };
  }

  componentDidMount() {
    fetch('/songs.json')
      .then(res => res.json())
      .then(
        (result) => {
          this.setState({
            titleClassName: 'sortable asc',
            artistClassName: 'sortable',
            difficultyClassName: 'sortable',
            songs: result.songs
          });
        },
        (error) => {
          console.log(error);
        }
      )
  }

  sortByTitle() {
    this.setState({
      titleClassName: 'sortable asc',
      artistClassName: 'sortable',
      difficultyClassName: 'sortable',
      songs: this.state.songs.sort((a, b) => {
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
      songs: this.state.songs.sort((a, b) => {
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
      songs: this.state.songs.sort((a, b) => {
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
          <th className={this.state.titleClassName} onClick={() => this.sortByTitle()}>
            Title
          </th>
          <th className={this.state.artistClassName} onClick={() => this.sortByArtist()}>
            Artist
          </th>
          <th className={this.state.difficultyClassName} onClick={() => this.sortByDifficulty()}>
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
        {this.state.songs.map((song) => <SongRow
            key={song.title}
            title={song.title}
            artist={song.artist}
            difficulty={song.difficulty}
            path={song.path}
            listen={song.listen}
        />)}
        </tbody>
      </table>
    )
  }
}
