import React from "react";
import * as PropTypes from "prop-types";

export class Photo extends React.Component {
  render() {
    return (
      <div className="card">
        <img src="..." className="card-img-top" alt="..." />
          <div className="card-body">
            <h5 className="card-title">Card title that wraps to a new line</h5>
            <p className="card-text">This is a longer card with supporting text below as a natural lead-in to
              additional content. This content is a little bit longer.</p>
          </div>
      </div>
    )
  }
}

Photo.propTypes = {
  photo: PropTypes.object.isRequired,
};


export class PhotoGallery extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      photos: []
    };
  }

  componentDidMount() {
    console.log("Fetching...");
    fetch('https://api.meetup.com/2/photos?&sign=true&photo-host=public&group_urlname=nycmss&page=20', {
      mode: 'cors'
    })
      .then(res => res.json())
      .then(
        (result) => {
          console.log(result);
          this.setState({
            photos: result
          });
        },
        (error) => {
          console.log(error);
        }
      )
  }

  render() {
    console.log("render");
    return (
      <div>
        {this.state.photos.map((photo) => <Photo photo={photo} />)}
      </div>
    )
  }
}
