import React from 'react';
import { observer } from 'mobx-react';
import { Col, Glyphicon, Image, ListGroup, ListGroupItem, Row , Popover, OverlayTrigger} from 'react-bootstrap';

const img = 'data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==';

const LongDesc = ({book}) => (
  <Popover id="popover-trigger-hover-focus" title="Description">
    {book.description}
  </Popover>
);


const Book = ({book, addToWishList}) => (
  <a className="book" onClick={addToWishList}>
    <h4 className="book-title">{book.name}</h4>
    <p className="text-muted book-author">by {book.author}, AR Pts: {book.ar_points}</p>
    <Image src={book.imageUrl} alt="" responsive className="book-cover" />
    <p className="text-muted book-description">{book.description}</p>
    <OverlayTrigger trigger={['hover', 'focus']} placement="right" overlay={LongDesc(book={book})}>
      <a href="#">Full Description</a>
    </OverlayTrigger>
  </a>
);

export default observer(({store}) => (
  <div>
    {store.searchResults.map((r, i) => <Book key={i} book={r} addToWishList={() => store.addToWishList(r)} />)}
  </div>
));
