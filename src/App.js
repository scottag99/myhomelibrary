import React, { Component } from 'react';
import { Grid } from 'react-bootstrap';
import BookCatalogSearch from './containers/BookCatalogSearch';
import './App.css';

const store = {
  wishlist: [
    { id: 1, name: 'Book Title' },
    { id: 2, name: 'Book Title vol. 2' },
    { id: 3, name: 'Another Book Title' }
  ],
  results: [
    {},
    {},
    {},
    {},
    {}
  ]
};

class App extends Component {
  render() {
    return (
      <Grid fluid className="App">
        <BookCatalogSearch store={store} />
      </Grid>
    );
  }
}

export default App;
