import React from "react";
import {SongRow} from "./songRow";

export class SongTable extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            yearClassName: 'sortable',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable',
            chordsClassName: 'sortable',
            pageClassName: 'sortable',
            songs: [],
        };
    }

    componentDidMount() {
        fetch('/songs.json')
            .then(res => res.json())
            .then(
                (result) => {
                    this.setState({
                        titleClassName: 'sortable',
                        artistClassName: 'sortable',
                        yearClassName: 'sortable',
                        tempoClassName: 'sortable',
                        difficultyClassName: 'sortable asc',
                        chordsClassName: 'sortable',
                        pageClassName: 'sortable',
                        songs: result.songs
                    }, this.sortByDifficulty);
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
            yearClassName: 'sortable',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable',
            pageClassName: 'sortable',
            songs: this.state.songs.sort((a, b) => {
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
                return 0;
            })
        })
    };

    sortByYear() {
        this.setState({
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            yearClassName: 'sortable asc',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable',
            pageClassName: 'sortable',
            songs: this.state.songs.sort((a, b) => {
                if (a.year < b.year) return -1;
                if (a.year > b.year) return 1;

                // Sort songs with the same year by title
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
            })
        })
    };

    sortByTempo() {
        this.setState({
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            yearClassName: 'sortable ',
            tempoClassName: 'sortable asc',
            difficultyClassName: 'sortable',
            chordsClassName: 'sortable',
            pageClassName: 'sortable',
            songs: this.state.songs.sort((a, b) => {
                if (Number(a.tempo) < Number(b.tempo)) return -1;
                if (Number(a.tempo) > Number(b.tempo)) return 1;

                // Sort songs with the same tempo by title
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
            })
        })
    };

    sortByArtist() {
        this.setState({
            titleClassName: 'sortable',
            artistClassName: 'sortable asc',
            yearClassName: 'sortable',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable',
            chordsClassName: 'sortable',
            pageClassName: 'sortable',
            songs: this.state.songs.sort((a, b) => {
                const aName = a.artist.replace(/^The /, "");
                const bName = b.artist.replace(/^The /, "");

                if (aName < bName) return -1;
                if (aName > bName) return 1;

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
            yearClassName: 'sortable',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable asc',
            chordsClassName: 'sortable',
            pageClassName: 'sortable',
            songs: this.state.songs.sort((a, b) => {
                if (a.difficulty < b.difficulty) return -1;
                if (a.difficulty > b.difficulty) return 1;

                // Sort songs by the same artist alphabetically
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
            })
        })
    };

    sortByChords() {
        this.setState({
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            yearClassName: 'sortable',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable',
            chordsClassName: 'sortable asc',
            pageClassName: 'sortable',
            songs: this.state.songs.sort((a, b) => {
                if (a.chord_count < b.chord_count) return -1;
                if (a.chord_count > b.chord_count) return 1;

                // Sort songs by the same artist alphabetically
                if (a.title < b.title) return -1;
                if (a.title > b.title) return 1;
            })
        })
    };

    sortByPage() {
        this.setState({
            titleClassName: 'sortable',
            artistClassName: 'sortable',
            yearClassName: 'sortable',
            tempoClassName: 'sortable',
            difficultyClassName: 'sortable',
            pageClassName: 'sortable asc',
            songs: this.state.songs.sort((a, b) => {
                if (a.page < b.page) return -1;
                if (a.page > b.page) return 1;
            })
        })
    };

    render() {
        return (
            <table className="table table-hover table-sm">
                <thead>
                <tr>
                    <th className={this.state.titleClassName} onClick={() => this.sortByTitle()}>
                        Title
                    </th>
                    <th className={this.state.artistClassName} onClick={() => this.sortByArtist()}>
                        Artist
                    </th>
                    <th className={this.state.yearClassName} onClick={() => this.sortByYear()}>
                        <span className="d-none d-lg-inline">Year</span>
                        <i className="d-lg-none fas fa-history fa-fw"/>
                    </th>
                    <th className={this.state.tempoClassName} onClick={() => this.sortByTempo()}>
                        <span className="d-none d-lg-inline">Tempo</span>
                        <i className="d-lg-none fas fa-drum fa-fw"/>
                    </th>
                    <th className={this.state.difficultyClassName} onClick={() => this.sortByDifficulty()}>
                        <span className="d-none d-lg-inline">Difficulty</span>
                        <i className="d-lg-none fas fa-graduation-cap fa-fw"/>
                    </th>
                    <th className={this.state.chordsClassName} onClick={() => this.sortByChords()}>
                        <span className="d-none d-lg-inline">Chords</span>
                        <i className="d-lg-none fas fa-guitar fa-fw"/>
                    </th>
                    <th className={this.state.pageClassName} onClick={() => this.sortByPage()}>
                        <span className="d-none d-lg-inline">Page</span>
                        <i className="d-lg-none fas fa-book fa-fw"/>
                    </th>
                </tr>
                </thead>
                <tbody>
                {this.state.songs.map((song) => <SongRow
                    key={song.title}
                    title={song.title}
                    artist={song.artist}
                    tempo={song.tempo}
                    musicalKey={song.key}
                    year={song.year}
                    difficulty={song.difficulty}
                    path={song.path}
                    listen={song.spotify}
                    page={song.page}
                    chordCount={song.chord_count}
                />)}
                </tbody>
            </table>
        )
    }
}
