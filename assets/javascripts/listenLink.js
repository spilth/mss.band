import React from "react";
import * as PropTypes from "prop-types";

export function ListenLink(props) {
    return <a href={props.href}>
        <span className="d-none d-md-inline">Listen</span>
        <i className="d-md-none fas fa-play fa-fw"/>
    </a>;
}

ListenLink.propTypes = {
    href: PropTypes.string.isRequired
};
