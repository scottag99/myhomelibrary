import React from 'react';
import { Col, Glyphicon, ListGroup, ListGroupItem, Row } from 'react-bootstrap';

const WishListItem = ({ book }) => (
  <ListGroupItem>
    {book.name}
    <Glyphicon glyph="remove" className="pull-right" />
  </ListGroupItem>
);

export default function({store}) {
  return (
    <div>
      <h3>My Wish List</h3>
      <ListGroup>
        {store.wishlist.map((w) => <WishListItem key={w.id} book={w}/>)}
      </ListGroup>
    </div>
  )
}
