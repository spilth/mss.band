import React from "react";
import * as PropTypes from "prop-types";

export function DifficultyLabel(props) {
    if (props.difficulty === "1") {
        return <span className="badge badge-success">E<span className="d-none d-md-inline">asy</span></span>
    } else {
        return <span className="badge badge-warning">M<span className="d-none d-md-inline">edium</span></span>
    }
}

DifficultyLabel.propTypes = {
    difficulty: PropTypes.string
};
