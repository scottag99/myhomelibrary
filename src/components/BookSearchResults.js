import React from 'react';
import { observer } from 'mobx-react';
import { Col, Glyphicon, Image, ListGroup, ListGroupItem, Row , Popover, OverlayTrigger} from 'react-bootstrap';

const img = 'data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==';

const LongDesc = ({book}) => (
  <Popover id="popover-trigger-hover-focus" title="Description">
    <p>{book.description}</p>
    {book.ar_points &&
        <span> <strong>AR Pts</strong>: {book.ar_points}</span>
    }
    {book.grl &&
        <span> <strong>GRL</strong>: {book.grl}</span>
    }
    {book.dra &&
        <span> <strong>DRA</strong>: {book.dra}</span>
    }
  </Popover>
);


const Book = ({book, addToWishList}) => (

  <div className="book">
    <h4 className="book-title">{book.name}</h4>
    <p className="text-muted book-author">by {book.author}</p>
    <div className="book-desc-box">
      <Image src={book.imageUrl} alt="" responsive className="book-cover" />
      <p className="text-muted book-description">{book.description}</p>
      <OverlayTrigger trigger={['hover', 'focus', 'click']} placement="right" overlay={LongDesc(book={book})}>
        <span className="text-info">Full Description</span>
      </OverlayTrigger>
    </div>
    <button onClick={addToWishList} className="btn btn-primary">Add</button>
  </div>
);

export default observer(({store}) => (
  <Row>
    <Col xs={12} md={12}>
    {store.searchResults.map((r, i) => <Book key={i} book={r} addToWishList={() => store.addToWishList(r)} />)}
    </Col>
  </Row>
));
