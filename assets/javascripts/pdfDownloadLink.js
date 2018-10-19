import React from "react";
import * as PropTypes from "prop-types";

export function PdfDownloadLink(props) {
    return <a href={"/pdfs/" + props.filename + ".pdf"}>
        <span className="d-none d-md-inline">Download</span>
        <i className="d-md-none fas fa-file-pdf fa-fw"/>
    </a>;
}

PdfDownloadLink.propTypes = {
    filename: PropTypes.string.isRequired
};

