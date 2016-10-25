import React from 'react';
import { observer } from 'mobx-react';
import { Button, FormControl, Input, InputGroup } from 'react-bootstrap';

export default observer(({store}) => (
  <div>
    <h3>Find Books</h3>
    <InputGroup>
      <InputGroup.Button>
        <Button>Reading Level</Button>
      </InputGroup.Button>
      <FormControl
        type="search"
        value={store.searchTerm}
        onChange={(e) => store.searchTerm = e.target.value }
      />
    </InputGroup>
  </div>
));
