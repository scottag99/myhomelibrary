import React from 'react';
import { observer } from 'mobx-react';
import { Col, Glyphicon, ListGroup, ListGroupItem, Row } from 'react-bootstrap';

const WishListItem = ({ book, handleRemoveFromWishList }) => (
  <ListGroupItem>
    {book.name}
    <button onClick={handleRemoveFromWishList} className="close btn-sm">
      <Glyphicon bsSize="small" glyph="remove" />
    </button>
  </ListGroupItem>
);

const WishList = ({store}) => {
  let children = store.wishlist.map((w) => <WishListItem key={w.id} book={w} handleRemoveFromWishList={() => store.removeFromWishList(w)} />);

  if(store.wishlist.length === 0) {
    children = (
      <ListGroup>
        <ListGroupItem>Your wish list is empty...</ListGroupItem>
      </ListGroup>
    );
  }

  return (
    <div>
      <h3>My Wish List</h3>
      <ListGroup>
        {children}
      </ListGroup>
    </div>
  );
}

export default observer(WishList);
