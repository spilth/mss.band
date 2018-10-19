import React from "react";
import * as PropTypes from "prop-types";
import {DifficultyLabel} from "./difficultyLabel";
import {ListenLink} from "./listenLink";
import {PdfDownloadLink} from "./pdfDownloadLink";
import {ViewLink} from "./viewLink";

export function SongRow(props) {
    return <tr>
        <td>
            <ViewLink path={props.songpro} title={props.title}/>
        </td>
        <td>
            {props.artist}
        </td>
        <td>
            <DifficultyLabel difficulty={props.difficulty}/>
        </td>
        <td>
            <PdfDownloadLink filename={props.songpro}/>
        </td>
        <td>
            <ListenLink href={props.listen}/>
        </td>
    </tr>;
}

SongRow.propTypes = {
    title: PropTypes.string.isRequired,
    artist: PropTypes.string.isRequired,
    listen: PropTypes.string.isRequired,
    difficulty: PropTypes.number,
    songpro: PropTypes.string,
};
