import React from 'react';
import { observer } from 'mobx-react';
import { Col, Glyphicon, Image, ListGroup, ListGroupItem, Row } from 'react-bootstrap';

const img = 'data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==';

const Book = ({book, addToWishList}) => (
  <a className="book" onClick={addToWishList}>
    <Image src={book.imageUrl} width="200" height="100" alt="" responsive />
    <h4>{book.name}</h4>
    <span className="text-muted">{book.subname}</span>
  </a>
);

export default observer(({store}) => (
  <div>
    {store.searchResults.map((r, i) => <Book key={i} book={r} addToWishList={() => store.addToWishList(r)} />)}
  </div>
));
