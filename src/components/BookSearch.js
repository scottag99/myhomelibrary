import React from 'react';
import { observer } from 'mobx-react';
import { FormControl, Row, Col } from 'react-bootstrap';

export default observer(({store}) => (
    <Row>
      <Col sm={4} lg={9}>
        <FormControl
          type="search"
          value={store.searchTerm}
          onChange={(e) => store.searchTerm = e.target.value }
          placeholder="Search"
        />
      </Col>
    </Row>
));
