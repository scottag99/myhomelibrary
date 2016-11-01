import { action, computed, observable } from 'mobx';

class AppState {
  @observable
  searchTerm = "Books...";

  @observable
  wishlist = [];

  @observable
  books = [];

  constructor() {
    this.wishlist = current_wishlist;//current_wishlist is defined on _wishlist.html.erb
    this.books = all_active_books;//all_active_books is defined on _wishlist.html.erb

  }
  readingLevels = [
    'PreK-G2',
    'G3-G5'
  ];

  searchTerm = "";

  @computed
  get searchResults() {
    const term = this.searchTerm.toLowerCase();

    return this.books
      .filter(book => book.name.toLowerCase().indexOf(term) >= 0 || book.author.toLowerCase().indexOf(term) >= 0 || book.description.toLowerCase().indexOf(term) >= 0)
      //.filter(book => book.author.toLowerCase().indexOf(term) >= 0)
      .filter(book => !this.wishlist.find((wish) => wish.catalog_entry_id === book.catalog_entry_id));
  }

  @action
  addToWishList(book) {
    if(this.wishlist.find((b) => b.catalog_entry_id === book.catalog_entry_id)) {
      return;
    }

    $.ajax({
      url: api_add_url,
      dataType: 'json',
      method: 'POST',
      data: {wishlist_entry: {catalog_entry_id: book.catalog_entry_id}},
      success: function(data) {
        book.id = data.id;
        appState.wishlist = appState.wishlist.concat(book);
      }
    });
  }

  @action
  removeFromWishList(book) {
    $.ajax({
      url: api_delete_url.replace(':id', book.id),
      dataType: 'json',
      method: 'DELETE',
      success: function(data) {
        book.id = null;
        appState.wishlist = appState.wishlist.filter(b => b.catalog_entry_id !== book.catalog_entry_id);
      }
    });
  }
}

const appState = new AppState();

export default appState;
export { AppState };
