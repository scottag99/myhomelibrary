import React, { Component } from 'react';
import { Grid } from 'react-bootstrap';
import BookCatalogSearch from './containers/BookCatalogSearch';
import state from './stores/AppState';
import './App.css';

class App extends Component {
  render() {
    return (
      <Grid fluid className="App">
        <BookCatalogSearch store={state} />
      </Grid>
    );
  }
}

export default App;
