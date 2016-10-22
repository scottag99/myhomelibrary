import React from 'react';
import { Col, Glyphicon, Image, ListGroup, ListGroupItem, Row } from 'react-bootstrap';

const img = 'data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==';

const Book = () => (
  <div className="book">
    <Image src={img} width="100" height="100" alt="" responsive />
    <h4>Name</h4>
    <span className="text-muted">Something else</span>
  </div>
);

export default function({store}) {
  return (
    <div>
      {store.results.map((r, i) => <Book key={i} book={r} />)}
    </div>
  )
}
