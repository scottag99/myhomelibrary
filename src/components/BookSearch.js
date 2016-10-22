import React from 'react';
import { Button, FormControl, Input, InputGroup } from 'react-bootstrap';

export default function() {
  return (
    <div>
      <h3>Find Books</h3>
      <InputGroup>
        <InputGroup.Button>
          <Button>Reading Level</Button>
        </InputGroup.Button>
        <FormControl type="search" />
      </InputGroup>
    </div>
  )
}
