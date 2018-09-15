import React from "react";

export class SongRow extends React.Component {
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