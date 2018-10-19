import React from "react";
import * as PropTypes from "prop-types";

export function ViewLink(props) {
    return <a href={"/songs/" + props.path}>{props.title}</a>;
}

ViewLink.propTypes = {
    path: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
};
