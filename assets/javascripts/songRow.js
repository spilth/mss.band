import React from "react";
import * as PropTypes from "prop-types";
import {DifficultyLabel} from "./difficultyLabel";
import {ViewLink} from "./viewLink";

export function SongRow(props) {
    return <tr>
        <td>
            <ViewLink path={props.path} title={props.title}/>
        </td>
        <td>
            {props.artist}
        </td>
        <td>
            {props.year}
        </td>
        <td>
            {props.tempo}
        </td>
        <td>
            <DifficultyLabel difficulty={props.difficulty}/>
        </td>
        <td>
            {props.page}
        </td>
    </tr>;
}

SongRow.propTypes = {
    title: PropTypes.string.isRequired,
    artist: PropTypes.string.isRequired,
    listen: PropTypes.string.isRequired,
    tempo: PropTypes.string,
    musicalKey: PropTypes.string,
    year: PropTypes.string,
    difficulty: PropTypes.string,
    path: PropTypes.string,
    page: PropTypes.number,
};
