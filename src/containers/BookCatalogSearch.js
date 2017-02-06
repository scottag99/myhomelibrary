import React from 'react';
import { Col } from 'react-bootstrap';

import WishList from '../components/WishList';
import BookSearch from '../components/BookSearch';
import BookSearchResults from '../components/BookSearchResults';

export default function({store}) {
  return (
    <div className="row">
      <Col lg={3}>
        <WishList store={store} />
      </Col>
      <Col lg={9}>
        <BookSearch store={store} />
        <BookSearchResults store={store} />
      </Col>
  </div>
  );
}
