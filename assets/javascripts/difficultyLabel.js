import React from "react";
import * as PropTypes from "prop-types";

export function DifficultyLabel(props) {
    if (props.difficulty === "0") {
        return <span className="badge badge-primary">B<span className="d-none d-md-inline">eginner</span></span>
    } else if (props.difficulty === "1") {
        return <span className="badge badge-success">E<span className="d-none d-md-inline">asy</span></span>
    } else if (props.difficulty === "2") {
        return <span className="badge badge-warning">M<span className="d-none d-md-inline">edium</span></span>
    } else if (props.difficulty === "3") {
        return <span className="badge badge-danger">H<span className="d-none d-md-inline">ard</span></span>
    }
}

DifficultyLabel.propTypes = {
    difficulty: PropTypes.string
};
