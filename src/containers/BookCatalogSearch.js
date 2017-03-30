import React from 'react';
import { Row, Col } from 'react-bootstrap';

import WishList from '../components/WishList';
import BookFilter from '../components/BookFilter';
import BookSearch from '../components/BookSearch';
import BookSearchResults from '../components/BookSearchResults';

export default function({store}) {
  return (
    <div>
      <div id="modal-container"></div>
      <Row>
        <Col lg={3}>
          <WishList store={store} />
        </Col>
        <Col lg={9} sm={9} smOffset={3}>
          <BookFilter store={store} />
          <BookSearch store={store} />
          <BookSearchResults store={store} />
        </Col>
      </Row>
    </div>
  );
}
