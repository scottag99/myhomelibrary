import React from 'react';
import { observer } from 'mobx-react';
import { Col, Image, Glyphicon, ListGroup, ListGroupItem, Row, Button, Panel } from 'react-bootstrap';

const WishListItem = ({ book, handleRemoveFromWishList }) => (
  <ListGroupItem>
    <span className="thumb-book-cover">
      <Image src={book.imageUrl} alt="Cover Image" className="img-responsive" />
    </span>
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

  const title = <h2>Wish List for {store.reader}</h2>

  return (
    <div data-spy="affix" className="current-wishlist">
      <Panel bsStyle="primary" header={title}>
        {store.grl &&
          <h6>Reading Level: {store.grl}</h6>
        }
        <ListGroup fill>
          {children}
        </ListGroup>
      </Panel>
      <Button bsStyle="primary" href='#' onClick={store.goBack}>Done</Button>
    </div>
  );
}

export default observer(WishList);
