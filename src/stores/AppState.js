import { action, computed, observable } from 'mobx';

class AppState {
  @observable
  searchTerm = "Books...";

  @observable
  wishlist = [
  ];

  @observable
  books = [
    {
      id: 1,
      name: 'A Wild Ride on the Water Cycle',
      subname: 'A Jake & Alice Adventure',
      imageUrl: 'http://brightskypress.com/wp-content/book-samples/images/watercycle_web_image.jpg'
    },
    {
      id: 2,
      name: 'Danielle & The Strawberry Fairies',
      subname: 'How Strawberries Become Red',
      imageUrl: 'http://brightskypress.com/wp-content/book-samples/images/daniellestrawfairies_web_image.jpg'
    },
    {
      id: 3,
      name: 'David & the Mighty Eighth',
      subname: '',
      imageUrl: 'http://brightskypress.com/wp-content/book-samples/images/davidmighty8_web_image.jpg'
    },
  ];

  readingLevels = [
    'PreK-G2',
    'G3-G5'
  ];

  searchTerm = "";

  @computed
  get searchResults() {
    const term = this.searchTerm.toLowerCase();

    return this.books
      .filter(book => book.name.toLowerCase().indexOf(term) >= 0)
      .filter(book => !this.wishlist.find((wish) => wish.id === book.id));
  }

  @action
  addToWishList(book) {
    if(this.wishlist.find((b) => b.id === book.id)) {
      return;
    }

    this.wishlist = this.wishlist.concat(book);
  }

  @action
  removeFromWishList(book) {
    this.wishlist = this.wishlist.filter(b => b.id !== book.id);
  }
}

const appState = new AppState();

export default appState;
export { AppState };
